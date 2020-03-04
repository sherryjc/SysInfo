//
//  NetIfcInfoView.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct NetIfcInfoView: View {

    var netIfcInfo: NetworkIfcInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            HStack {
                Text("ID:")
                Spacer()
                Text(netIfcInfo.id)
            } .padding(.all).background(Clr.bg_gray1)
            HStack {
                Text("IP address:")
                Text("(\(netIfcInfo.family))")
                Spacer()
                Text(netIfcInfo.ipAddr)
            } .padding(.all).background(Clr.bg_gray2)
            HStack {
                Text("Subnet mask:")
                Spacer()
                Text(netIfcInfo.subnetMask)
            } .padding(.all).background(Clr.bg_gray1)
            HStack {
                Text("Router:")
                Spacer()
                Text(netIfcInfo.router)
            } .padding(.all).background(Clr.bg_gray2)
        }
    }
}

struct NetIfcInfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        NetIfcInfoView(netIfcInfo: DeviceData.netIfcDataIpv4[0])
    }
}
