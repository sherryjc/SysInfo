//
//  ContentView.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var userData : UserData

    let deviceInfoView = DeviceInfoView(deviceInfo: DeviceData.deviceInfo)
    let netIfcArrViewIpv4 = NetIfcInfoArrView(netIfcInfoArr: DeviceData.netIfcDataIpv4)
    let netIfcArrViewIpv6 = NetIfcInfoArrView(netIfcInfoArr: DeviceData.netIfcDataIpv6)
    let wifiInfoView = WifiInfoView(wifiInfos: DeviceData.wifiInfos)

    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination: deviceInfoView) {
                        Text("This Device")
                            .foregroundColor(Color.blue)
                    }
                    NavigationLink(destination: netIfcArrViewIpv4) {
                        Text("IPV4 Network Interfaces")
                            .foregroundColor(Color.blue)
                    }
                    NavigationLink(destination: netIfcArrViewIpv6) {
                        Text("IPV6 Network Interfaces")
                            .foregroundColor(Color.blue)
                    }
                    NavigationLink(destination: wifiInfoView){
                        Text("Wifi Info")
                            .foregroundColor(Color.blue)
                    }
                    NavigationLink(destination: ConnectView().environmentObject(self.userData)){
                        Text("Test Connections")
                            .foregroundColor(Color.blue)
                    }
                }.navigationBarTitle("System Info")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
