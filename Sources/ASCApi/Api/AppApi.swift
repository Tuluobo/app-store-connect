//
//  AppApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import HTTP
import Vapor

public final class AppApi {
    
    /// Get App List
    /// /v1/apps
    /// - Parameter container: HTTP Container
    public static func getAppList(on container: Container) throws -> Future<AppListResponse> {
        guard let token = try ASCApiManager.default.api?.getToken() else {
            throw ASError.token
        }
        var headers = HTTPHeaders()
        headers.bearerAuthorization = BearerAuthorization(token: token)
        return try container.client().get(baseURL + "/v1/apps", headers: headers).flatMap({ (response) -> Future<AppListResponse> in
            return try response.content.decode(AppListResponse.self)
        })
    }
    
    /// Get App Info
    /// /v1/apps/{id}
    /// - Parameter id: App id
    /// - Parameter container: HTTP Container
    public static func getAppInfo(id: String, on container: Container) throws -> Future<AppInfoResponse> {
        guard let token = try ASCApiManager.default.api?.getToken() else {
            throw ASError.token
        }
        var headers = HTTPHeaders()
        headers.bearerAuthorization = BearerAuthorization(token: token)
        return try container.client().get(baseURL + "/v1/apps/\(id)", headers: headers).flatMap({ (response) -> Future<AppInfoResponse> in
            return try response.content.decode(AppInfoResponse.self)
        })
    }
    
}
