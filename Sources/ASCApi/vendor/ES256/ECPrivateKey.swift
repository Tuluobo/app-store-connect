//  Copyright © 2019 IBM. All rights reserved.
//
//     Licensed under the Apache License, Version 2.0 (the "License");
//     you may not use this file except in compliance with the License.
//     You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//     Unless required by applicable law or agreed to in writing, software
//     distributed under the License is distributed on an "AS IS" BASIS,
//     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//     See the License for the specific language governing permissions and
//     limitations under the License.
//
import Foundation
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import CommonCrypto
#elseif os(Linux)
import OpenSSL
#endif

@available(OSX 10.13, *)
public class ECPrivateKey {
    /// A String description of the curve this key was generated from.
    public let curveId: String

    /// The `EllipticCurve` this key was generated from.
    public let curve: EllipticCurve

    /// The private key represented as a PEM String.
    public let pemString: String

    #if os(Linux)
    typealias NativeKey = OpaquePointer?
    deinit { EC_KEY_free(.make(optional: self.nativeKey)) }
    #else
    typealias NativeKey = SecKey
    #endif
    let nativeKey: NativeKey
    let pubKeyBytes: Data
    private var stripped: Bool = false

    /// Initialize an ECPrivateKey from a PKCS8 `.der` file data.
    /// This is equivalent to a PEM String that has had the "-----BEGIN PRIVATE KEY-----"
    /// header and footer stripped and been base64 encoded to ASN1 Data.
    /// - Parameter pkcs8DER: The elliptic curve private key Data.
    /// - Returns: An ECPrivateKey.
    /// - Throws: An ECError if the Data can't be decoded or is not a valid key.
    public init(pkcs8DER: Data) throws {
        let (result, _) = ASN1.toASN1Element(data: pkcs8DER)
        guard case let ASN1.ASN1Element.seq(elements: es) = result,
            es.count > 2,
            case let ASN1.ASN1Element.seq(elements: ids) = es[1],
            ids.count > 1,
            case let ASN1.ASN1Element.bytes(data: privateKeyID) = ids[1]
            else {
                throw ECError.failedASN1Decoding
        }
        self.curve = try EllipticCurve.objectToCurve(ObjectIdentifier: privateKeyID)
        guard case let ASN1.ASN1Element.bytes(data: privateOctest) = es[2] else {
            throw ECError.failedASN1Decoding
        }
        let (octest, _) = ASN1.toASN1Element(data: privateOctest)
        guard case let ASN1.ASN1Element.seq(elements: seq) = octest,
            seq.count >= 3,
            case let ASN1.ASN1Element.bytes(data: privateKeyData) = seq[1]
            else {
                throw ECError.failedASN1Decoding
        }
        let publicKeyData: Data
        if case let ASN1.ASN1Element.constructed(tag: 1, elem: publicElement) = seq[2],
            case let ASN1.ASN1Element.bytes(data: pubKeyData) = publicElement
        {
            publicKeyData = pubKeyData
        } else if seq.count >= 4,
            case let ASN1.ASN1Element.constructed(tag: 1, elem: publicElement) = seq[3],
            case let ASN1.ASN1Element.bytes(data: pubKeyData) = publicElement
        {
            publicKeyData = pubKeyData
        } else {
            throw ECError.failedASN1Decoding
        }
        let trimmedPubBytes = publicKeyData.drop(while: { $0 == 0x00})
        if trimmedPubBytes.count != publicKeyData.count {
            stripped = true
        }
        self.nativeKey =  try ECPrivateKey.bytesToNativeKey(privateKeyData: privateKeyData,
                                                            publicKeyData: trimmedPubBytes,
                                                            curve: curve)
        let derData = ECPrivateKey.generateASN1(privateKey: privateKeyData,
                                                publicKey: publicKeyData,
                                                curve: curve)
        self.pemString = ECPrivateKey.derToPrivatePEM(derData: derData)
        self.pubKeyBytes = trimmedPubBytes
        self.curveId = curve.description
    }
}


@available(OSX 10.13, *)
extension ECPrivateKey {

    private static func generateASN1(privateKey: Data, publicKey: Data, curve: EllipticCurve) -> Data {
        var keyHeader: Data
        // Add the ASN1 header for the private key. The bytes have the following structure:
        // SEQUENCE (4 elem)
        //     INTEGER 1
        //     OCTET STRING (32 byte) (This is the `privateKeyBytes`)
        //     [0] (1 elem)
        //         OBJECT IDENTIFIER
        //     [1] (1 elem)
        //         BIT STRING (This is the `pubKeyBytes`)
        if curve == .prime256v1 {
            keyHeader = Data([0x30, 0x77,
                              0x02, 0x01, 0x01,
                              0x04, 0x20])
            keyHeader += privateKey
            keyHeader += Data([0xA0,
                               0x0A, 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, 0x07,
                               0xA1,
                               0x44, 0x03, 0x42])
            keyHeader += publicKey
        } else if curve == .secp384r1 {
            keyHeader = Data([0x30, 0x81, 0xA4,
                              0x02, 0x01, 0x01,
                              0x04, 0x30])
            keyHeader += privateKey
            keyHeader += Data([0xA0,
                               0x07, 0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x22,
                               0xA1,
                               0x64, 0x03, 0x62])
            keyHeader += publicKey
        } else {
            // 521 Private key can be 65 or 66 bytes long
            if privateKey.count == 65 {
                keyHeader = Data([0x30, 0x81, 0xDB,
                                  0x02, 0x01, 0x01,
                                  0x04, 0x41])
            } else {
                keyHeader = Data([0x30, 0x81, 0xDC,
                                  0x02, 0x01, 0x01,
                                  0x04, 0x42])
            }
            keyHeader += privateKey
            keyHeader += Data([0xA0,
                               0x07, 0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x23,
                               0xA1,
                               0x81, 0x89, 0x03, 0x81, 0x86])
            keyHeader += publicKey
        }
        return keyHeader
    }

    private static func bytesToNativeKey(privateKeyData: Data, publicKeyData: Data, curve: EllipticCurve) throws -> NativeKey {
        #if os(Linux)
        let bigNum = BN_new()
        defer {
            BN_free(bigNum)
        }
        privateKeyData.withUnsafeBytes({ (privateKeyBytes: UnsafeRawBufferPointer) -> Void in
            BN_bin2bn(privateKeyBytes.baseAddress?.assumingMemoryBound(to: UInt8.self), Int32(privateKeyData.count), bigNum)
        })
        let ecKey = EC_KEY_new_by_curve_name(curve.nativeCurve)
        guard EC_KEY_set_private_key(ecKey, bigNum) == 1 else {
            EC_KEY_free(ecKey)
            throw ECError.failedNativeKeyCreation
        }
        return ecKey
        #else
        let keyData = publicKeyData + privateKeyData
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(keyData as CFData,
                                                [kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                                                 kSecAttrKeyClass: kSecAttrKeyClassPrivate] as CFDictionary,
                                                &error)
            else {
                if let secError = error?.takeRetainedValue() {
                    throw secError
                } else {
                    throw ECError.failedNativeKeyCreation
                }
        }
        return secKey
        #endif
    }

    private static func derToPrivatePEM(derData: Data) -> String {
        // First convert the DER data to a base64 string...
        let base64String = derData.base64EncodedString()
        // Split the string into strings of length 64.
        let lines = base64String.split(to: 64)
        // Join those lines with a new line...
        let joinedLines = lines.joined(separator: "\n")
        return "-----BEGIN EC PRIVATE KEY-----\n" + joinedLines + "\n-----END EC PRIVATE KEY-----"
    }
}
