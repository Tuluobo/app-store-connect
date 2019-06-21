//
//  JWT+ES256.swift
//  APNS
//
//  Created by Anthony Castelli on 4/1/18.
//

import Foundation
//import CNIOOpenSSL
//import Crypto
import JWT

public enum JWTError: Error {
    case invalidP8
    case invalidPrivateKey
    case wrongAlgorithm
    case unknown(Error)
}

@available(OSX 10.13, *)
final class ES256: JWTAlgorithm {

    private let curve: EllipticCurve = .prime256v1

    private let key: Data

    var jwtAlgorithmName: String {
        return "ES256"
    }

    init(key: Data) throws {
        self.key = key
    }

    func sign(_ plaintext: LosslessDataConvertible) throws -> Data {
        guard let keyString = String(data: key, encoding: .utf8) else {
            throw JWTError.invalidPrivateKey
        }
        let asn1 = try keyString.toASN1()
        let privateKey = try ECPrivateKey(pkcs8DER: asn1)
        guard privateKey.curve == curve else {
            throw JWTError.invalidPrivateKey
        }
        let signedData = try plaintext.convertToData().sign(with: privateKey)
        return signedData.r + signedData.s
    }

    func verify(_ signature: LosslessDataConvertible, signs plaintext: LosslessDataConvertible) throws -> Bool {
        return true
    }
}

public typealias P8 = String
extension P8 {
    /// Convert PEM format .p8 file to DER-encoded ASN.1 data
    public func toASN1() throws -> Data {
        let base64 = self
            .split(separator: "\n")
            .filter({ $0.hasPrefix("-----") == false })
            .joined(separator: "")

        guard let asn1 = Data(base64Encoded: base64) else {
            throw JWTError.invalidP8
        }
        return asn1
    }
}
