//
//  Response.swift
//  ASCApi
//
//  Created by WangHao on 2019/7/9.
//

import Foundation

// MARK: - List Response

public struct ListResponse<T>: Model where T: Model {
    let data: [T]
    let links: Link
    let meta: PagingInformation
    // The requested relationship data.
    // Possible types: BundleId, Device, Certificate, Profile, BundleIdCapability
    //    let included: [T]?
}

// MARK: - Info Response

public struct InfoResponse<T>: Model where T: Model {
    let data: T
    let links: Link
    // The requested relationship data.
    // Possible types: BundleId, Device, Certificate, Profile, BundleIdCapability
    //    let included: [T]?
}
