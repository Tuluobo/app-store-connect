//
//  CommonModels.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import Vapor

public typealias Model = Content

enum ResourceType: String, Model {
    case apps = "apps"
    case users = "users"
}

struct ResourceModel: Model {
    let id: String
    let type: ResourceType
}

public struct Link: Model {
    let `self`: String
    let related: String?
}

public struct PagingInformation: Model {
    let paging: Paging
}

public struct Paging: Model {
    let total: Int
    let limit: Int
}

// MARK: - Update Request
public struct UpdateRequest<T>: Model where T: Model {
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

