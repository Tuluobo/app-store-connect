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

/// The signature produced by applying an Elliptic Curve Digital Signature Algorithm to some Plaintext data.
/// It consists of two binary unsigned integers, `r` and `s`.

public struct ECSignature {

    // MARK: Signature Values

    /// The r value of the signature.
    /// The size of the signature data depends on the Secure Hash Algorithm used; it will be 32 bytes of data for SHA256, 48 bytes for SHA384, or 66 bytes for SHA512.
    public let r: Data

    /// The s value of the signature.
    /// The size of the signature data depends on the Secure Hash Algorithm used; it will be 32 bytes of data for SHA256, 48 bytes for SHA384, or 66 bytes for SHA512.
    public let s: Data

    /// The r and s values of the signature encoded into an ASN1 sequence.
    public let asn1: Data

    /// Initialize an ECSignature by providing an ASN1 encoded sequence containing the r and s values.
    /// - Parameter asn1: The r and s values of the signature encoded as an ASN1 sequence.
    /// - Returns: A new instance of `ECSignature`.
    /// - Throws: An ECError if the ASN1 data can't be decoded.
    public init(asn1: Data) throws {
        self.asn1 = asn1
        let (r,s) = try ECSignature.asn1ToRSSig(asn1: asn1)
        self.r = r
        self.s = s
    }

    static func asn1ToRSSig(asn1: Data) throws -> (Data, Data) {

        let signatureLength: Int
        if asn1.count < 96 {
            signatureLength = 64
        } else if asn1.count < 132 {
            signatureLength = 96
        } else {
            signatureLength = 132
        }

        // Parse ASN into just r,s data as defined in:
        // https://tools.ietf.org/html/rfc7518#section-3.4
        let (asnSig, _) = ASN1.toASN1Element(data: asn1)
        guard case let ASN1.ASN1Element.seq(elements: seq) = asnSig,
            seq.count >= 2,
            case let ASN1.ASN1Element.bytes(data: rData) = seq[0],
            case let ASN1.ASN1Element.bytes(data: sData) = seq[1]
            else {
                throw ECError.failedASN1Decoding
        }
        // ASN adds 00 bytes in front of negative Int to mark it as positive.
        // These must be removed to make r,a a valid EC signature
        let trimmedRData: Data
        let trimmedSData: Data
        let rExtra = rData.count - signatureLength/2
        if rExtra < 0 {
            trimmedRData = Data(count: 1) + rData
        } else {
            trimmedRData = rData.dropFirst(rExtra)
        }
        let sExtra = sData.count - signatureLength/2
        if sExtra < 0 {
            trimmedSData = Data(count: 1) + sData
        } else {
            trimmedSData = sData.dropFirst(sExtra)
        }
        return (trimmedRData, trimmedSData)
    }
}
