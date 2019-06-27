//
//  Certificate.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation

enum CertificateType: String, Model {
    case iosDevelopment = "IOS_DEVELOPMENT"
    case iosDistribution = "IOS_DISTRIBUTION"
    case macDistribution = "MAC_APP_DISTRIBUTION"
    case macDevelopment = "MAC_APP_DEVELOPMENT"
    case macInstallerDistribution = "MAC_INSTALLER_DISTRIBUTION"
    case developmentIDKext = "DEVELOPER_ID_KEXT"
    case developmentIDApplication = "DEVELOPER_ID_APPLICATION"
}

public struct Certificate: Model {
    
    struct Attribute: Model {
        let certificateContent: String
        let displayName: String
        let expirationDate: String
        let name: String
        let platform: BundleIdPlatform
        let serialNumber: String
        let certificateType: CertificateType
    }
    
    let id: String
    let type: ResourceType
    let attributes: Attribute
    let links: Link
}

// MARK: - Certificate List Response

public struct CertificateListResponse: Model {
    let data: [Certificate]
    let links: Link
    let meta: PagingInformation
}

// MARK: - Certificate Response

public struct CertificateResponse: Model {
    let data: Certificate
    let links: Link
}
