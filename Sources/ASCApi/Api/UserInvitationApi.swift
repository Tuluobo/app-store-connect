//
//  UserInvitationApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation
import Vapor

public final class UserInvitationApi: Api {
    public init() { }
    
    /// Get a list of pending invitations to join your team.
    /// /userInvitations
    /// - Parameter container: HTTP Container
    public func getInvitedList(on container: Container) throws -> Future<UserListResponse> {
        return try container.client().get(self.basePath + "/userInvitations", beforeSend: { try $0.addToken() }).flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Get information about a pending invitation to join your team.
    /// /userInvitations/{id}
    /// - Parameter id: User id
    /// - Parameter container: HTTP Container
    public func getInvitedUser(id: String, on container: Container) throws -> Future<UserInfoResponse> {
        return try container.client().get(self.basePath + "/userInvitations/\(id)", beforeSend: { try $0.addToken() }).flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Invite a user with assigned user roles to join your team.
    /// - Parameter user: UserInvitation Object
    /// - Parameter container: HTTP Container
    public func inviteUser(user: UserInvitation, on container: Container) throws -> Future<UserInfoResponse> {
        return try container.client().post(self.basePath + "/userInvitations") {
            try $0.addToken()
            let content = RequestContent(data: user)
            try $0.content.encode(content)
        }.flatMap({ (response) in
            return try response.handler()
        })
    }
    
    /// Cancel a pending invitation for a user to join your team.
    /// - Parameter id: User Id
    /// - Parameter container: HTTP Container
    public func deleteInvitedUser(id: String, on container: Container) throws -> Future<UserInfoResponse> {
        return try container.client().post(self.basePath + "/userInvitations/\(id)") { try $0.addToken() }.flatMap({ (response) in
            return try response.handler()
        })
    }
}
