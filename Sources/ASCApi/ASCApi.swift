import Foundation
import JWT

let host = "https://api.appstoreconnect.apple.com"


public final class ASCApiManager {
    
    public static let `default` = ASCApiManager()
    public var api: ASCApi?
    
    public func startService(iss: String, kid: String, keyPath: String) throws {
        self.api = try ASCApi(iss: iss, kid: kid, keyPath: keyPath)
    }
}

public final class ASCApi {
    
    enum TokenError: Error {
        case tokenWasNotGeneratedCorrectly
    }
    
    struct ASAPIPayload: JWTPayload {
        let iss: String
        let exp = ExpirationClaim(value: Date(timeInterval: 20 * 60, since: Date()))
        let aud: String? = "appstoreconnect-v1"
        
        func verify(using signer: JWTSigner) throws {
            try self.exp.verifyNotExpired()
        }
    }
    
    private let key: Data
    private let header: JWTHeader
    private var payload: ASAPIPayload
        
    init(iss: String, kid: String, keyPath: String) throws {
        self.key = try Data(contentsOf: URL(fileURLWithPath: keyPath))
        self.header = JWTHeader(alg: "ES256", kid: kid)
        self.payload = ASAPIPayload(iss: iss)
    }
    
    public func token() throws -> String {
        return try generateToken()
    }
    
    /// Generate token
    func generateToken() throws -> String {
        let signer: JWTSigner
        if #available(OSX 10.13, *) {
            signer = JWTSigner(algorithm: try ES256(key: self.key))
        } else {
            fatalError("Not Support")
        }
        let jwt = JWT(header: header, payload: payload)
        let signed = try jwt.sign(using: signer)
        guard let t = String(bytes: signed, encoding: .utf8) else {
            throw TokenError.tokenWasNotGeneratedCorrectly
        }
        return t
    }
}
