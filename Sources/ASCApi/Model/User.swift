//
//  User.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation

public struct User: Model {
    
    enum UserRole: String, Model {
        case admin      = "ADMIN"
        case finance    = "FINANCE"
        case tachnical  = "TECHNICAL"
        case sales      = "SALES"
        case marketing  = "MARKETING"
        case developer       = "DEVELOPER"
        case accountHolder   = "ACCOUNT_HOLDER"
        case readOnly        = "READ_ONLY"
        case appManager      = "APP_MANAGER"
        case accessToReports = "ACCESS_TO_REPORTS"
        case customerSupport = "CUSTOMER_SUPPORT"
    }
    
    /// User's Attributes.
    struct Attribute: Model {
        let username: String
        let firstName: String
        let lastName: String
        let roles: [UserRole]
        let provisioningAllowed: Bool
        let allAppsVisible: Bool
    }
    
    struct Relationship: Model {
        
        /// Included resource types and IDs.
        struct VisibleApp: Model {
            let links: Link
            let data: [ResourceModel]?
            let meta: PagingInformation?
        }
        
        let visibleApps: VisibleApp
    }
    
    let id: String
    let type: ResourceType
    let attributes: Attribute
    let relationships: Relationship
    let links: Link
}

public struct UserListResponse: Model {
    let data: [User]
    let links: Link
    let meta: PagingInformation
    let included: [App]?
}

// MARK: - User Info Response

public struct UserInfoResponse: Model {
    let data: User
    let links: Link
    let included: [App]?
}
