//
//  BundleIDApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation
import Vapor

public final class BundleIDApi: Api {
    public init() { }
    
    public func getBundleIDList(on container: Container) throws -> Future<BundleIDListResponse> {
        return try container.client().get(self.basePath + "/bundleIds") { try $0.addToken() }.flatMap { (response) in
            return try response.handler()
        }
    }
    
    public func create(bundleID: CreateBundleID, on container: Container) throws -> Future<BundleIDResponse> {
        return try container.client().get(self.basePath + "/bundleIds") {
            try $0.addToken()
            let content = RequestContent(data: bundleID)
            try $0.content.encode(content)
        }.flatMap { (response) in
            return try response.handler()
        }
    }
    
    public func update(bundleID: BundleID, on container: Container) throws -> Future<BundleIDResponse> {
        return try container.client().get(self.basePath + "/bundleIds/\(bundleID.id)") {
            try $0.addToken()
            let content = RequestContent(data: bundleID)
            try $0.content.encode(content)
            }.flatMap { (response) in
                return try response.handler()
        }
    }
    
    public func delete(id: String, on container: Container) throws -> Future<Void> {
        return try container.client().get(self.basePath + "/bundleIds/\(id)") {
            try $0.addToken()
        }.flatMap { (response) in
            return try response.handlerEmpty()
        }
    }
}
