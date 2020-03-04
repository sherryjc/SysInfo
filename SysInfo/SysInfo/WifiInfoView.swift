//
//  WifiInfoView.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct WifiInfoView: View {
    
    var wifiInfos: [WifiInfo]
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            List {
                HStack {
                    Text("Wifi Networks")
                    Spacer()
                    Text("\(wifiInfos.count)")
                }
                .padding(.all).background(Clr.blue1).foregroundColor(Clr.white1)
                ForEach(wifiInfos, id: \.id) { info in
                    WifiViewEntry(wifiInfo: info)
                }
            }
        }
    }
}

struct WifiInfoView_Previews: PreviewProvider {
    static var previews: some View {
        WifiInfoView(wifiInfos: DeviceData.wifiInfos)
    }
}
