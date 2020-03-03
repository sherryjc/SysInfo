//
//  WifiInfoView.swift
//  SysInfo
//
//  Created by Joe Sherry on 2/28/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

let bg1 = Color(red: 0.0, green: 0.0, blue: 0.9, opacity: 0.7)
let fg1 = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
let fg2 = Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)

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
                .padding(.all).background(bg1).foregroundColor(fg1)
                ForEach(wifiInfos, id: \.id) { info in
                    WifiViewEntry(wifiInfo: info)
                }
            }
        }
    }
}

struct WifiInfoView_Previews: PreviewProvider {
    static var previews: some View {
        WifiInfoView(wifiInfos: wifiInfos)
    }
}
