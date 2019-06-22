//
//  Api.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation
import Vapor

public protocol Api {
    
    var scheme: String { get }
    var baseURL: String { get }
    var version: String { get }
}

public extension Api {
    
    var basePath: String {
        return scheme + "://" + baseURL + "/" + version
    }
    
    var scheme: String {
        return "https"
    }
    var baseURL: String {
        return "api.appstoreconnect.apple.com"
    }
    var version: String {
        return "v1"
    }
}

extension Request {
    func addToken() throws {
        guard let token = try ASCApiManager.default.api?.getToken() else {
            throw ASError.token
        }
        var headers = self.http.headers
        headers.bearerAuthorization = BearerAuthorization(token: token)
        self.http.headers = headers
    }
}

extension Response {
    
    func handlerEmpty() throws -> Future<Void> {
        if self.http.status.code >= 200 && self.http.status.code < 300 {
            return self.future(())
        } else {
            return try self.content.decode(ErrorResponse.self).map { (e) in
                throw ASError.response(e)
            }
        }
    }
    
    func handler<T>() throws -> Future<T> where T: Model {
        if self.http.status.code >= 200 && self.http.status.code < 300 {
            return try self.content.decode(T.self)
        } else {
            return try self.content.decode(ErrorResponse.self).map { (e) in
                throw ASError.response(e)
            }
        }
    }
}
