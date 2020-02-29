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
    let bg1 = Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0)
    let bg2 = Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0)
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            HStack {
                Text("ID:")
                Spacer()
                Text(netIfcInfo.id)
            } .padding(.all).background(bg1)
            HStack {
                Text("IP address:")
                Text("(\(netIfcInfo.family))")
                Spacer()
                Text(netIfcInfo.ipAddr)
            } .padding(.all).background(bg2)
            HStack {
                Text("Subnet mask:")
                Spacer()
                Text(netIfcInfo.subnetMask)
            } .padding(.all).background(bg1)
            HStack {
                Text("Router:")
                Spacer()
                Text(netIfcInfo.router)
            } .padding(.all).background(bg2)
        }
    }
}

struct NetIfcInfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        NetIfcInfoView(netIfcInfo: netIfcData[0])
    }
}
