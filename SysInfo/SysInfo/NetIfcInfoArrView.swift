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
    let bg1 = Color(red: 0.0, green: 0.0, blue: 0.9, opacity: 0.7)
    let fg1 = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
    let fg2 = Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)
    

    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            List {
                HStack {
                    Text("Network Interfaces")
                    Spacer()
                    Text("\(netIfcInfoArr.count)")
                }
                .padding(.all).background(bg1).foregroundColor(fg1)
                
                ForEach(netIfcInfoArr, id: \.id) {info in
                        NetIfcInfoView(netIfcInfo: info)
                }
            }
        }
    }
}

struct NetIfcInfoArrView_Previews: PreviewProvider {
    static var previews: some View {
        NetIfcInfoArrView(netIfcInfoArr: netIfcData)
    }
}
