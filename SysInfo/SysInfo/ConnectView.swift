//
//  ConnectView.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct ConnectView: View {
    
    @State private var remoteHost: String = "Enter IP address or URL"
    let in_width: CGFloat = CGFloat(50)
    let in_height: CGFloat = CGFloat(20)
    let out_width: CGFloat = CGFloat(70)
    let out_height: CGFloat = CGFloat(120)
    let border_width: CGFloat = CGFloat(5)
    
    var body: some View {

        VStack(alignment: .center, spacing: 0.0) {
        List {
        
            HStack {
                Text("Test Connections")
                Spacer()
            }
            .padding(.all).background(Clr.bg_blue1).foregroundColor(Clr.fg_white1)
   
            Section {
                VStack {
                    Text("Remote host")
                        .font(.callout)
                        .padding(.all)
                   // TODO: research TextField
                   // TextField( text: $remoteHost).border(Color.black, width: border_width).frame(width: in_width, height: in_height)
                }
            }
   
            Section {
                VStack {
                    Text("Contacting \(remoteHost) ")
                        .frame(width: out_width, height: out_height)
                        .background(Clr.bg_paleYellow)
                }
            }
            .padding(.all)
 
        }
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
    }
}

