//
//  Device.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/22.
//

import Foundation

public struct Device: Model {

    struct Attribute: Model {
        let udid: String
        let name: String
        let platform: BundleIdPlatform
        let deviceClass: deviceType?
        let model: String?
        let status: EnableStatus?
        let addedDate: String?
    }

    let id: String
    let type: ResourceType
    let attributes: Attribute
    let links: Link
}

// MARK: - Request Device

public struct CreateDevice: Model {
    let type: ResourceType = .devices
    let attributes: Device.Attribute
}
