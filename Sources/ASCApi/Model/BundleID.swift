//
//  BundleID.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation

public struct BundleID: Model {
    struct Attribute: Model {
        
        let identifier: String
        let name: String
        let platform: BundleIdPlatform
        let seedId: String?
    }
    
    struct Relationship : Codable {
        let bundleIdCapabilities: ResourceListRelationship
        let profiles: ResourceListRelationship
    }
    
    let id: String
    let type: String
    let attributes: Attribute
    let links: Link?
    let relationships: Relationship?
}

public struct CreateBundleID: Model {
    let type: ResourceType = .bundleIds
    let attributes: BundleID.Attribute
}
