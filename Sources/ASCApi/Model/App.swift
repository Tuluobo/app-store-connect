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
        
        let betaAppLocalizations: BetaAppLocalization
        let betaAppReviewDetail: BetaAppLocalization
        let betaGroups: BetaAppLocalization
        let betaLicenseAgreement: BetaAppLocalization
        let betaTesters: BetaAppLocalization
        let builds: BetaAppLocalization
        let preReleaseVersions: BetaAppLocalization
    }
    
    let id: String
    let type: ResourceType
    let attributes: Attribute?
    let relationships: Relationship?
    let links: Link?
}

// MARK: - APP List Response

public struct AppListResponse: Model {
    let data: [App]
    let links: Link
    let meta: PagingInformation
}

// MARK: - APP Info Response
public struct AppInfoResponse: Model {
    let data: App
    let links: Link
}
