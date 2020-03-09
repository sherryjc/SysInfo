//
//  UserData.swift
//  SysInfo
//
//  Created by Joe Sherry on 3/6/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

// Encapsulates data entered by the user (which the UI needs to react to)
final class UserData: ObservableObject {
    // User enters this data
    @Published var remoteHost: String = ""
}
