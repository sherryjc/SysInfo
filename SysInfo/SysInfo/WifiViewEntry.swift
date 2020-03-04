//
//  WifiViewEntry.swift
//  SysInfo
//
//  Created by loaner on 3/2/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct WifiViewEntry: View {
    var wifiInfo: WifiInfo

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("ID:")
                Spacer()
                Text(wifiInfo.id)
            } .padding(.all).background(Clr.bg_gray1)
            HStack {
                Text("Data:")
                Spacer()
                Text(wifiInfo.data)
            } .padding(.all).background(Clr.bg_gray2)
        }
    }
}

struct WifiViewEntry_Previews: PreviewProvider {
    static var previews: some View {
        WifiViewEntry(wifiInfo: DeviceData.wifiInfos[0])
    }
}
