//
//  CommonModels.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import Vapor

public typealias Model = Content

// MARK: - Enum

enum EnableStatus: String, Model {
    case enabled = "ENABLED"
    case disabled = "DISABLED"
}

enum ResourceType: String, Model {
    case apps = "apps"
    case users = "users"
    case userInvitations = "userInvitations"
    case bundleIds = "bundleIds"
    case profiles = "profiles"
    case bundleIdCapabilities = "bundleIdCapabilities"
    case devices = "devices"
}

enum BundleIdPlatform: String, Model {
    case iOS = "IOS"
    case macOS = "MAC_OS"
}

enum deviceType: String, Model {
    case watch = "APPLE_WATCH"
    case iPad = "IPAD"
    case iPhone = "IPHONE"
    case iPod = "IPOD"
    case tv = "APPLE_TV"
    case mac = "MAC"
}

// MARK: - Common Model

struct ResourceModel: Model {
    let id: String
    let type: ResourceType
}

struct ResourceRelationship: Model {
    let links: Link
    let data: ResourceModel?
    let meta: PagingInformation?
}

/// Included resource types and IDs.
struct ResourceListRelationship: Model {
    let links: Link
    let data: [ResourceModel]?
    let meta: PagingInformation?
}

public struct Link: Model {
    let `self`: String
    let related: String?
    let next : String?
}

public struct PagingInformation: Model {
    let paging: Paging
}

public struct Paging: Model {
    let total: Int
    let limit: Int
}

// MARK: - Request Content

public struct RequestContent<T>: Model where T: Model {
    let data: T
}

// MARK: - Error Response

public struct ErrorResponse: Model {
    let errors: [ErrorInfo]
}

public struct ErrorInfo: Model {
    enum Source: String, Model {
        case pointer = "pointer"
        case parameter = "parameter"
    }
    
    let code: String
    let status: String
    let title: String
    let detail: String
    let id: String?
    let source: Source?
}


// MARK: - List Response

public struct ListResponse<T>: Model where T: Model {
    let data: [T]
    let links: Link
    let meta: PagingInformation
    // The requested relationship data.
    // Possible types: BundleId, Device, Certificate, Profile, BundleIdCapability
//    let included: [T]?
}

// MARK: - Info Response

public struct InfoResponse<T>: Model where T: Model {
    let data: T
    let links: Link
    // The requested relationship data.
    // Possible types: BundleId, Device, Certificate, Profile, BundleIdCapability
//    let included: [T]?
}
