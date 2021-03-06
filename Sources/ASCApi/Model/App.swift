//
//  App.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation

public struct App: Model {
    
    struct Attribute: Model {
        let bundleId : String
        let sku: String
        let name : String
        let primaryLocale: String
    }
    
    struct Relationship: Model {
        
        public struct BetaAppLocalization: Model {
            let links: Link
        }
        
        let betaAppLocalizations: ResourceListRelationship
        let betaAppReviewDetail: ResourceRelationship
        let betaGroups: ResourceListRelationship
        let betaLicenseAgreement: ResourceRelationship
        let betaTesters: ResourceListRelationship
        let builds: ResourceListRelationship
        let preReleaseVersions: ResourceListRelationship
    }
    
    let id: String
    let type: ResourceType
    let attributes: Attribute?
    let relationships: Relationship?
    let links: Link?
}
