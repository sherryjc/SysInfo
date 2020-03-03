//
//  DeviceInfoView.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct DeviceInfoView: View {
    var deviceInfo: DeviceInfo
    let bg1 = Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0)
    let bg2 = Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0)

    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            List {
                HStack {
                    Text("Host Name:")
                    Spacer()
                    Text(deviceInfo.hostName)
                } .padding(.all).background(bg1)
                HStack {
                    Text("Version:")
                    Spacer()
                    Text(deviceInfo.version)
                } .padding(.all).background(bg2)
                HStack {
                    Text("OS Type:")
                    Spacer()
                    Text(deviceInfo.osType)
                } .padding(.all).background(bg1)
                HStack {
                    Text("OS Version:")
                    Spacer()
                    Text(deviceInfo.osVersion)
                } .padding(.all).background(bg2)
                HStack {
                    Text("Active CPUs:")
                    Spacer()
                    Text("\(deviceInfo.activeCPUs)")
                } .padding(.all).background(bg1)
            }
        }
    }
}

struct DeviceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceInfoView(deviceInfo: DeviceData.deviceInfo)
    }
}
