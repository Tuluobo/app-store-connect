//
//  Request.swift
//  ASCApi
//
//  Created by WangHao on 2019/7/9.
//

import Foundation

public struct RequestContent<T>: Model where T: Model {
    let data: T
}
