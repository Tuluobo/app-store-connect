//
//  BundleIDApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation
import Vapor

public final class BundleIDApi: Api {
    
    public var resourceType: ResourceType {
        return .bundleIds
    }
    
    public init() { }
    
    /// Find and list bundle IDs that are registered to your team.
    /// GET /bundleIds
    /// - Parameter container: HTTP Container
    public func getBundleIDList(on container: Container) throws -> Future<ListResponse<BundleID>> {
        return try container.client().get(self.basePath) {
            try $0.addToken()
        }.flatMap {
            return try $0.handler()
        }
    }
    
    /// Register a new bundle ID for app development.
    /// POST /bundleIds
    /// - Parameter bundleID: Create BundleID Object
    /// - Parameter container: HTTP Container
    public func create(bundleID: CreateBundleID, on container: Container) throws -> Future<InfoResponse<BundleID>> {
        return try container.client().post(self.basePath) {
            try $0.addToken()
            let content = RequestContent(data: bundleID)
            try $0.content.encode(content)
        }.flatMap { (response) in
            return try response.handler()
        }
    }
    
    /// Update a specific bundle ID’s name.
    /// PATCH /bundleIds/{id}
    /// - Parameter bundleID: BundleID Object
    /// - Parameter container: HTTP Container
    public func update(bundleID: BundleID, on container: Container) throws -> Future<InfoResponse<BundleID>> {
        return try container.client().patch(self.basePath + "/\(bundleID.id)") {
            try $0.addToken()
            let content = RequestContent(data: bundleID)
            try $0.content.encode(content)
        }.flatMap { (response) in
            return try response.handler()
        }
    }
    
    /// Delete a bundle ID that is used for app development.
    /// DELETE /bundleIds/{id}
    /// - Parameter id: BundleID ID
    /// - Parameter container: HTTP Container
    public func delete(id: String, on container: Container) throws -> Future<Void> {
        return try container.client().delete(self.basePath + "/\(id)") {
            try $0.addToken()
        }.flatMap { (response) in
            return try response.handlerEmpty()
        }
    }
}
