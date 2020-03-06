//
//  UserData.swift
//  SysInfo
//
//  Created by Joe Sherry on 3/6/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

// Encapsulates other external data in addition to user data
final class UserData: ObservableObject {
    // User enters this data
    @Published var remoteHost: String = ""
    
    // This data comes back from external callbacks
    @Published var remoteIpAddr: String = ""
    @Published var outputRows: [RowItem] = [RowItem]()
}
