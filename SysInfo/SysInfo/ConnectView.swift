//
//  ConnectView.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import SwiftUI

struct ConnectView: View {
    
    @State private var remoteHost: String = ""
   
    var body: some View {

        VStack(alignment: .center, spacing: 0.0) {
        List {
        
            HStack {
                Text("Test Connections")
                Spacer()
            }
            .padding(.all).background(Clr.blue1).foregroundColor(Clr.white1)
   
            Section {
                VStack {
                    Text("Remote host")
                        .font(.subheadline).italic().foregroundColor(Clr.blue1)
                    TextField("Enter URL or IP address", text: $remoteHost).padding(.all).border(Color.blue, width: 1.0).background(Clr.paleYellow).textFieldStyle(RoundedBorderTextFieldStyle())
                }
            } .padding(.all)
            Section {
                VStack {
                    Text("Contacting \(remoteHost) ")
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .background(Clr.gray2).border(Clr.blue, width: 1.0)
                    
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

