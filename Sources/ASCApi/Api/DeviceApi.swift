//
//  DeviceApi.swift
//  ASCApi
//
//  Created by Hao Wang on 2019/6/24.
//

import Foundation
import Vapor

public final class DeviceApi: Api {
    public init() { }

    /// Register a new device for app development.
    /// POST /devices
    /// - Parameter device: Register Device
    /// - Parameter container: HTTP Container
    public func register(device: CreateDevice, on container: Container) throws -> Future<InfoResponse<Device>> {
        return try container.client().post(self.basePath + "/devices") {
            try $0.addToken()
            try $0.content.encode(RequestContent(data: device))
        }.flatMap {
            return try $0.handler()
        }
    }

    /// Find and list devices registered to your team.
    /// GET /devices
    /// - Parameter container: HTTP Container
    public func getDeviceList(on container: Container) throws -> Future<ListResponse<Device>> {
        return try container.client().get(self.basePath + "/devices") {
            try $0.addToken()
        }.flatMap {
            return try $0.handler()
        }
    }

    /// Get information for a specific device registered to your team.
    /// GET /devices/{id}
    /// - Parameter id: Device Id
    /// - Parameter container: HTTP Container
    public func getDeviceInfo(id: String, on container: Container) throws -> Future<InfoResponse<Device>> {
        return try container.client().get(self.basePath + "/devices/\(id)") {
            try $0.addToken()
        }.flatMap {
            return try $0.handler()
        }
    }

    /// Update the name or status of a specific device.
    /// PATCH /devices/{id}
    /// - Parameter device: Update Device
    /// - Parameter container: HTTP Container
    public func updateDevice(device: Device, on container: Container) throws -> Future<InfoResponse<Device>> {
        return try container.client().patch(self.basePath + "/devices/\(device.id)") {
            try $0.addToken()
            try $0.content.encode(RequestContent(data: device))
        }.flatMap {
            return try $0.handler()
        }
    }
}
