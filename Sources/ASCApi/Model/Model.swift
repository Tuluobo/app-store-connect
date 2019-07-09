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

public enum ResourceType: String, Model {
    case apps = "apps"
    case users = "users"
    case userInvitations = "userInvitations"
    case bundleIds = "bundleIds"
    case profiles = "profiles"
    case bundleIdCapabilities = "bundleIdCapabilities"
    case devices = "devices"
    case betaTesters = "betaTesters"
    case betaGroups = "betaGroups"
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

public struct ResourceModel: Model {
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
