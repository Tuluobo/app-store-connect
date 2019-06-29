//
//  Profile.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation

enum ProfileType: String, Model {
    case iosAppDevelopment  = "IOS_APP_DEVELOPMENT"
    case iosAppStore        = "IOS_APP_STORE"
    case iosAppAdHoc        = "IOS_APP_ADHOC"
    case iosAppInHouse      = "IOS_APP_INHOUSE"
    
    case macAppDevelopment  = "MAC_APP_DEVELOPMENT"
    case macAppStore        = "MAC_APP_STORE"
    case macAppDirect       = "MAC_APP_DIRECT"
    
    case tvOSAppDevelopment = "TVOS_APP_DEVELOPMENT"
    case tvOSAppStore       = "TVOS_APP_STORE"
    case tvOSAppAdHoc       = "TVOS_APP_ADHOC"
    case tvOSAppInHouse     = "TVOS_APP_INHOUSE"
}

enum ProfileState: String, Model {
    case active = "ACTIVE"
    case invlid = "INVALID"
}

public struct Profile: Model {
    
    struct Attribute: Model {
        let uuid: String
        let name: String
        let platform: BundleIdPlatform
        let profileType: ProfileType
        let profileContent: String
        let profileState: ProfileState
        
        let createdDate: String
        let expirationDate: String
    }
    
    struct Relationship: Model {
        struct Certificates: Model {
            let data: [ResourceModel]?
            let links: Link
            let meta: PagingInformation
        }
        
        struct Devices: Model {
            let data: [ResourceModel]?
            let links: Link
            let meta: PagingInformation
        }
        
        struct BundleID: Model {
            let data: ResourceModel?
            let links: Link
        }
        
        let certificates: Certificates
        let devices: Devices
        let bundleId: BundleID
    }
    
    let id: String
    let attributes: Attribute
    let relationships: Relationship?
    let type: ResourceType
    let links: Link
}
