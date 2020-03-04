//
//  NetIfcInfoArrView.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct NetIfcInfoArrView: View {
    
    var netIfcInfoArr: [NetworkIfcInfo]
   
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            List {
                HStack {
                    Text("Network Interfaces")
                    Spacer()
                    Text("\(netIfcInfoArr.count)")
                }
                .padding(.all).background(Clr.bg_blue1).foregroundColor(Clr.fg_white1)
                
                ForEach(netIfcInfoArr, id: \.id) {info in
                        NetIfcInfoView(netIfcInfo: info)
                }
            }
        }
    }
}

struct NetIfcInfoArrView_Previews: PreviewProvider {
    static var previews: some View {
        NetIfcInfoArrView(netIfcInfoArr: DeviceData.netIfcDataIpv4)
    }
}
