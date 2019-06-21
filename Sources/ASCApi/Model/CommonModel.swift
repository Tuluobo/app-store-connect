//
//  CommonModel.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/21.
//

import Foundation
import Vapor

public typealias Model = Content

public struct Link: Model {
    let `self`: String
    let related: String?
}

public struct ListMeta: Model {
    let paging: Paging
}

public struct Paging: Model {
    let total: Int
    let limit: Int
}
