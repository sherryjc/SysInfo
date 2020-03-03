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
    let bg1 = Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0)
    let bg2 = Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0)

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("ID:")
                Spacer()
                Text(wifiInfo.id)
            } .padding(.all).background(bg1)
            HStack {
                Text("Data:")
                Spacer()
                Text(wifiInfo.data)
            } .padding(.all).background(bg2)
        }
    }
}

struct WifiViewEntry_Previews: PreviewProvider {
    static var previews: some View {
        WifiViewEntry(wifiInfo: wifiInfos[0])
    }
}
