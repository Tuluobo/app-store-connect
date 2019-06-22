//
//  UserApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import Vapor

public final class UserApi: Api {
    
    public init() { }
    
    /// Get User List
    /// /users
    /// - Parameter container: HTTP Container
    public func getUserList(on container: Container) throws -> Future<UserListResponse> {
        return try container.client().get(self.basePath + "//users", beforeSend: { try $0.addToken() }).flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Get User Info
    /// /users/{id}
    /// - Parameter id: User id
    /// - Parameter container: HTTP Container
    public func getUserInfo(id: String, on container: Container) throws -> Future<UserInfoResponse> {
        return try container.client().get(self.basePath + "/users/\(id)", beforeSend: { try $0.addToken() }).flatMap { (response) in
            return try response.handler()
        }
    }
    
    /// Update User Info
    /// /users/{id}
    /// - Parameter user: Update User
    /// - Parameter container: HTTP Container
    public func updateUser(user: User, on container: Container) throws -> Future<UserInfoResponse> {
        return try container.client().patch(self.basePath + "/users/\(user.id)") { (request) in
            try request.addToken()
            let update = UpdateRequest(data: user)
            try request.content.encode(update)
        }.flatMap { (response) in
            return try response.handler()
        }
    }
    
}
