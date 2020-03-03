//
//  Device.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

let strIpv4 = "Ipv4"
let strIpv6 = "Ipv6"
let strUnknown = "Unknown"

struct Device {
    static func getFamilyAsStr(sa_family: UInt8) -> String {
        switch sa_family {
        case UInt8(AF_INET):
            return strIpv4
        case UInt8(AF_INET6):
            return strIpv6
        default:
            return "Unknown"
        }
    }
    
    static func getNetworkIpv4IfcInfo() -> [NetworkIfcInfo] {
        return getNetworkIfcInfo(family: UInt8(AF_INET))
    }
    
    static func getNetworkIpv6IfcInfo() -> [NetworkIfcInfo] {
        return getNetworkIfcInfo(family: UInt8(AF_INET6))
    }
    
    static func getNetworkIfcInfo(family: UInt8) -> [NetworkIfcInfo] {
        var ifcs = [NetworkIfcInfo]()

        let unknownAddr = "0.0.0.0"
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }

        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            let ifcId = ptr.pointee.ifa_name.pointee
            let ifcName = String(ifcId)

            // Check for running interfaces that match the input arg 'family'. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == family {

                    // Convert interface address members to human readable strings:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    
                    // The Ip address of the interface
                    var address: String = unknownAddr
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                     nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        address = String(cString: hostname)
                    }
                    // The netmask of the interface
                    var netmask: String = unknownAddr
                    if (getnameinfo(ptr.pointee.ifa_netmask, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                       netmask = String(cString: hostname)
                    }
                    // The router for the interface
                    var router: String = unknownAddr
                    if (getnameinfo(ptr.pointee.ifa_dstaddr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                       router = String(cString: hostname)
                    }

                    let ifc = NetworkIfcInfo(id: ifcName, ipAddr: address, family: getFamilyAsStr(sa_family: addr.sa_family), subnetMask: netmask, router: router)
                    ifcs.append(ifc)

                }
            }
        }

         freeifaddrs(ifaddr)
         return ifcs
    }

    static func getWiFiInfos() -> [WifiInfo] {
        
        var infos = [WifiInfo]()
        var ssid: String?
        var ssidData: String?
        var dataStr: String = "<empty>"
        
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    if let id = ssid {
                        ssidData = interfaceInfo[kCNNetworkInfoKeySSIDData as String] as? String
                        if (ssidData != nil) {
                            dataStr = ssidData!
                        }
                        let info = WifiInfo(id: id, data: dataStr)
                        infos.append(info)
                    }
                }
            }
        }
        return infos
    }

    static func getDeviceInfo() -> DeviceInfo {
        let deviceInfo = DeviceInfo(hostName: Sysctl.hostName,
                                    version: Sysctl.version,
                                    osType: Sysctl.osType,
                                    osVersion: Sysctl.osVersion,
                                    activeCPUs: Sysctl.activeCPUs
                                    )
        return deviceInfo
    }
}


// Original
func getIFAddresses() -> [String] {
    var addresses = [String]()

    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return [] }
    guard let firstAddr = ifaddr else { return [] }

    // For each interface ...
    for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let flags = Int32(ptr.pointee.ifa_flags)
        let addr = ptr.pointee.ifa_addr.pointee

        // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
        if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
            if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                    let address = String(cString: hostname)
                    addresses.append(address)
                }
            }
        }
    }

    freeifaddrs(ifaddr)
    return addresses
}


