//
//  ASError.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import Vapor

public enum ASError: Error {
    case token
    case response(ErrorResponse)
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

#if DEBUG

extension ASError: Debuggable {
    public var identifier: String {
        return "com.tuluobo.ascapi"
    }
    
    public var reason: String {
        switch self {
        case .token:
            return "Token error"
        case .response(let error):
            return "\(error)"
        }
    }
}

#endif

