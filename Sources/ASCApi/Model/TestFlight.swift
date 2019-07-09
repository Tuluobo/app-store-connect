//
//  TestFlight.swift
//  ASCApi
//
//  Created by WangHao on 2019/7/8.
//

import Foundation

public struct BetaTesterCreateRequest: Model {
    
    struct Attribute: Model {
        let email: String
        let firstName: String?
        let lastName: String
    }
    
    struct Relationship: Model {
        let betaGroups: RequestContent<[ResourceModel]>
        let builds: RequestContent<[ResourceModel]>
    }
    
    let type: ResourceType = .betaTesters
    let attributes: Attribute
    let relationships: Relationship
}


public struct BetaTester: Model {
    
    enum BetaInviteType: String, Model {
        case email = "EMAIL"
        case publicLink = "PUBLIC_LINK"
    }
    
    struct Attribute: Model {
        let inviteType: BetaInviteType
        let email: String
        let firstName: String
        let lastName: String

    }
    
    struct Relationship: Model {
        let apps: ResourceListRelationship
        let betaGroups: ResourceListRelationship
        let builds: ResourceListRelationship
    }
    
    let id: String
    let type: ResourceType
    let attributes: Attribute
    let relationships: Relationship?
    let links: Link
    
    
}
