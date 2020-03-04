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

    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            List {
                HStack {
                    Text("This Device")
                    Spacer()
                }
                .padding(.all).background(Clr.bg_blue1).foregroundColor(Clr.fg_white1)
                HStack {
                    Text("Host Name:")
                    Spacer()
                    Text(deviceInfo.hostName)
                } .padding(.all).background(Clr.bg_gray1)
                HStack {
                    Text("Version:")
                    Spacer()
                    Text(deviceInfo.version)
                } .padding(.all).background(Clr.bg_gray2)
                HStack {
                    Text("OS Type:")
                    Spacer()
                    Text(deviceInfo.osType)
                } .padding(.all).background(Clr.bg_gray1)
                HStack {
                    Text("OS Version:")
                    Spacer()
                    Text(deviceInfo.osVersion)
                } .padding(.all).background(Clr.bg_gray2)
                HStack {
                    Text("Active CPUs:")
                    Spacer()
                    Text("\(deviceInfo.activeCPUs)")
                } .padding(.all).background(Clr.bg_gray1)
            }
        }
    }
}

struct DeviceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceInfoView(deviceInfo: DeviceData.deviceInfo)
    }
}
