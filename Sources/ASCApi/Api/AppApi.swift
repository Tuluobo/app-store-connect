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
    
    public var resourceType: ResourceType {
        return .apps
    }
    
    public init() { }
    
    /// Get App List
    /// GET /v1/apps
    /// - Parameter container: HTTP Container
    public func getAppList(on container: Container) throws -> Future<ListResponse<App>> {
        return try container.client().get(self.basePath) {
            try $0.addToken()
        }.flatMap {
            return try $0.handler()
        }
    }
    
    /// Get App Info
    /// GET /v1/apps/{id}
    /// - Parameter id: App id
    /// - Parameter container: HTTP Container
    public func getAppInfo(id: String, on container: Container) throws -> Future<InfoResponse<App>> {
        return try container.client().get(self.basePath + "/\(id)") {
            try $0.addToken()
        }.flatMap {
            return try $0.handler()
        }
    }
}
