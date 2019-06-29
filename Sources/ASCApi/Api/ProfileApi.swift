//
//  ProfileApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/28.
//

import Foundation
import Vapor

public final class ProfileApi: Api {
    public init() { }
    
    /// Find and list provisioning profiles and download their data.
    /// GET /profiles
    /// - Parameter container: HTTP Container
    public func getProfileList(on container: Container) throws -> Future<ListResponse<Profile>> {
        return try container.client().get(self.basePath + "/profiles", beforeSend: { try $0.addToken() }).flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Get information for a specific provisioning profile and download its data.
    /// GET /profiles/{id}
    /// - Parameter id: Profile ID
    /// - Parameter container: HTTP Container
    public func getProfileInfo(id: String, on container: Container) throws -> Future<InfoResponse<Profile>> {
        return try container.client().get(self.basePath + "/profiles/\(id)", beforeSend: { try $0.addToken() }).flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Get the bundle ID information for a specific provisioning profile.
    /// GET /profiles/{id}/bundleId
    /// - Parameter id: Profile ID
    /// - Parameter container: HTTP Container
    public func getBundleIdInProfile(id: String, on container: Container) throws -> Future<InfoResponse<BundleID>> {
        return try container.client().get(self.basePath + "/profiles/\(id)/bundleId") { try $0.addToken() }.flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Delete a provisioning profile
    /// DELETE /profiles/{id}
    /// - Parameter id: Profile ID
    /// - Parameter container: HTTP Container
    public func deleteProfile(id: String, on container: Container) throws -> Future<Void> {
        return try container.client().delete(self.basePath + "/profiles/\(id)") {
            try $0.addToken()
        }.flatMap { (response) in
            return try response.handlerEmpty()
        }
    }
    
}
