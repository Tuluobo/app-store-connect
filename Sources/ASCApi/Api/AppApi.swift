//
//  AppApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import HTTP
import Vapor

public final class AppApi: Api {
    
    public init() { }
    
    /// Get App List
    /// GET /v1/apps
    /// - Parameter container: HTTP Container
    public func getAppList(on container: Container) throws -> Future<AppListResponse> {
        return try container.client().get(self.basePath + "/apps", beforeSend: { try $0.addToken() }).flatMap({ (response) -> Future<AppListResponse> in
            return try response.handler()
        })
    }
    
    /// Get App Info
    /// GET /v1/apps/{id}
    /// - Parameter id: App id
    /// - Parameter container: HTTP Container
    public func getAppInfo(id: String, on container: Container) throws -> Future<AppInfoResponse> {
        return try container.client().get(self.basePath + "/apps/\(id)", beforeSend: { try $0.addToken() }).flatMap({ (response) -> Future<AppInfoResponse> in
            return try response.handler()
        })
    }
}
