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
    public func getUserList(on container: Container) throws -> Future<ListResponse<User>> {
        return try container.client().get(self.basePath + "/users") {
            try $0.addToken()
        }.flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Get User Info
    /// /users/{id}
    /// - Parameter id: User id
    /// - Parameter container: HTTP Container
    public func getUserInfo(id: String, on container: Container) throws -> Future<InfoResponse<User>> {
        return try container.client().get(self.basePath + "/users/\(id)") {
            try $0.addToken()
        }.flatMap { (response) in
            return try response.handler()
        }
    }
    
    /// Update User Info
    /// /users/{id}
    /// - Parameter user: Update User
    /// - Parameter container: HTTP Container
    public func updateUser(user: User, on container: Container) throws -> Future<InfoResponse<User>> {
        return try container.client().patch(self.basePath + "/users/\(user.id)") { (request) in
            try request.addToken()
            let update = RequestContent(data: user)
            try request.content.encode(update)
        }.flatMap { (response) in
            return try response.handler()
        }
    }
    
    /// Delete User
    /// /users/{id}
    /// - Parameter id: User id
    /// - Parameter container: HTTP Container
    public func deleteUser(id: String, on container: Container) throws -> Future<Void> {
        return try container.client().delete(self.basePath + "/users/\(id)") { (request) in
            try request.addToken()
        }.flatMap { (response) in
            return try response.handlerEmpty()
        }
    }
    
}
