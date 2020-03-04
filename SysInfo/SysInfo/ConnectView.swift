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
    @State private var outputText: String = ""
    
    var body: some View {

        ZStack {
            Clr.gray1
       
            VStack(alignment: .center, spacing: 0.0) {
        
                HStack {
                    Text("Test Connections")
                    Spacer()
                }
                .padding(.all).background(Clr.blue1).foregroundColor(Clr.white1)
   
            
                VStack {
                    Text("Contact remote host")
                        .font(.subheadline).italic().foregroundColor(Clr.blue1).padding(.top)
                    TextField("Enter URL or IP address", text: $remoteHost).padding(.all).border(Color.blue, width: 1.0).background(Clr.blue1).textFieldStyle(RoundedBorderTextFieldStyle())
                }
        
                HStack {
                    Button(action: {
                        self.outputText = "Awaiting ping response"
                        self.outputText = Connect.getPingResponse(ipAddr: self.remoteHost)
                    }) {
                        Text("     Ping      ").font(.subheadline)
                    }
                    .padding(.all)
                    .border(Clr.blue1, width: 5)
                    .background(Clr.green1)
                    .foregroundColor(Clr.white1)
                    
                    Button(action: {
                        self.outputText = "Awaiting URL response"
                    }) {
                        Text("URL request").font(.subheadline)
                    }
                    .padding(.all)
                    .border(Clr.blue1, width: 5)
                    .background(Clr.green1)
                    .foregroundColor(Clr.white1)
                    
                }.padding(.all)
            
                HStack {
                    Text("Contacting host:")
                        .padding(.horizontal)
                    Spacer()
                    Text("\(remoteHost)").foregroundColor(Clr.red1)
                }
                .padding(.all)

            
                HStack {
                    Text(outputText)
                        .padding(.horizontal)
                    
                }.frame(minWidth: 200, idealWidth: 400.0, minHeight: 400, idealHeight: 500.0)
            
            }
            Spacer()
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
    }
}

