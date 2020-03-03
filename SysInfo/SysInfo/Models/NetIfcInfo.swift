//
//  NetIfcInfo.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

// Serializable version for testing by reading from a file
struct NetworkIfcInfoFile: Hashable, Codable, Identifiable {
    var id: String
    var ipAddr: String
    var family: String
    var subnetMask: String
    var router: String
    static func == (lhs: NetworkIfcInfoFile, rhs: NetworkIfcInfoFile) -> Bool {
        return lhs.id == rhs.id
    }
}

struct NetworkIfcInfo: Identifiable {
    public var id: String
    var ipAddr: String
    var family: String
    var subnetMask: String
    var router: String
}
