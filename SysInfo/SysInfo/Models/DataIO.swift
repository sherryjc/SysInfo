//
//  DataIO.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

// Always load the JSON file to support previews
let netIfcTestFileData : [NetworkIfcInfoFile] = load("NetIfcInfo.json")

// Use test data from the JSON file: uncomment this line
//let netIfcData = extract(fileData: netIfcTestFileData)

// Use real data from the device: uncomment this section
let netIfcDataIpv4 = getNetworkIpv4IfcInfo();
let netIfcDataIpv6 = getNetworkIpv6IfcInfo();


func extract(fileData: [NetworkIfcInfoFile] ) -> [NetworkIfcInfo] {
    var outArray = [NetworkIfcInfo]()
    for fi in fileData {
        outArray.append(NetworkIfcInfo(id: fi.id, ipAddr: fi.ipAddr, family: fi.family, subnetMask: fi.subnetMask, router: fi.router))
    }
    return outArray
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

