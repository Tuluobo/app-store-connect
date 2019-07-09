//
//  TestFlightApi.swift
//  ASCApi
//
//  Created by WangHao on 2019/7/8.
//

import Foundation
import Vapor

public final class TestFlightApi: Api {
    
    public var resourceType: ResourceType {
        return .betaTesters
    }
    
    public init() { }
    
    /// Find and list beta testers for all apps, builds, and beta groups.
    /// GET /betaTesters
    /// - Parameter container: HTTP Container
    public func betaTestersList(on container: Container) throws -> Future<ListResponse<BetaTester>> {
        return try container.client().get(self.basePath) {
            try $0.addToken()
        }.flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Get a specific beta tester.
    /// GET /betaTesters/{id}
    /// - Parameter id: An opaque resource ID that uniquely identifies the resource.
    /// - Parameter container: HTTP Container
    public func betaTesterInfo(id: String, on container: Container) throws -> Future<InfoResponse<BetaTester>> {
        return try container.client().get(self.basePath + "/\(id)") {
            try $0.addToken()
        }.flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Create a beta tester assigned to a group, a build, or an app.
    /// POST /betaTesters
    /// - Parameter betaTester: HTTP Body
    /// - Parameter container: HTTP Container
    public func createBetaTesters(create betaTester: BetaTesterCreateRequest, on container: Container) throws -> Future<InfoResponse<BetaTester>> {
        return try container.client().post(self.basePath) {
            try $0.addToken()
            let content = RequestContent(data: betaTester)
            try $0.content.encode(content)
        }.flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Remove a beta tester's ability to test all apps.
    /// DELETE /betaTesters/{id}
    /// - Parameter id: An opaque resource ID that uniquely identifies the resource.
    /// - Parameter container: HTTP Container
    public func deleteBetaTesters(id: String, on container: Container) throws -> Future<Void> {
        return try container.client().delete(self.basePath + "/\(id)") {
            try $0.addToken()
        }.flatMap({ (response) in
            return try response.handlerEmpty()
        })
    }
    
    /// Add a beta tester to one or more specific beta groups.
    /// - Parameter id: Beta Tester ID
    /// - Parameter groupId: Group ID
    /// - Parameter container: HTTP Container
    public func addBetaTesterToGroup(id: String, groupId: [String], on container: Container) throws -> Future<Void> {
        return try container.client().post(self.basePath + "/\(id)/relationships/betaGroups") {
            try $0.addToken()
            let content = RequestContent(data: groupId.map { ResourceModel(id: $0, type: .betaGroups) })
            try $0.content.encode(content)
        }.flatMap({ (response) in
            return try response.handlerEmpty()
        })
    }
}
