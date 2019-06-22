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

