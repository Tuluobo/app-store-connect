//
//  AppModel.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import Vapor

public struct AppModel: Model {
    
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
    let type: String
    let attributes: Attribute
    let relationships: Relationship?
    let links: Link
}

// MARK: - APP List

public struct AppListResponse: Model {
    let data: [AppModel]
    let links: Link
    let meta: ListMeta
}

// MARK: - APP Info
public struct AppInfoResponse: Model {
    let data: AppModel
    let links: Link
}
