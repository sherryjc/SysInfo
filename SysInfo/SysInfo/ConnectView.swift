//
//  ConnectView.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//


import SwiftUI

struct ConnectViewRow: View  {

    var status: ConnectStatus
    var rowText: String
    
    var body: some View {
        
        if status == ConnectStatus.fail {
            return HStack {
                Text("[FAIL] ").foregroundColor(Clr.red1).multilineTextAlignment(.leading)
                Text(rowText).multilineTextAlignment(.leading)
                Spacer()
            }
        } else {
            return HStack {
                Text("[OK] ").foregroundColor(Clr.green1).multilineTextAlignment(.leading)
                Text(rowText).multilineTextAlignment(.leading)
                Spacer()
            }
        }
    }
}

struct ConnectView: View {
    
    @EnvironmentObject private var userData : UserData
    @ObservedObject var dispData = Connect.connectDispData
    let pingAttempts: UInt8 = 4
    
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
                    TextField("Enter URL or IP address", text: $userData.remoteHost).padding(.all).border(Color.blue, width: 1.0).background(Clr.blue1).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                }
        
                HStack {
                    Button(action: {
                        if (!self.userData.remoteHost.isEmpty) {
                            Connect.ping(self.userData.remoteHost, self.pingAttempts)
                        }
                    }) {
                        Text("     Ping      ").font(.subheadline).bold()
                    }
                    .padding(.all)
                    .foregroundColor(Clr.white1)
                    .background(LinearGradient(gradient: Gradient(colors: [Clr.green1, Clr.blue1]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40.0)

                    Button(action: {
                        //self.outputText = "Awaiting URL response"
                    }) {
                        Text("URL request").font(.subheadline).bold()
                    }
                    .padding(.all)
                    .foregroundColor(Clr.white1)
                    .background(LinearGradient(gradient: Gradient(colors: [Clr.blue1, Clr.green1]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40.0)

                }.padding(.all)
            
                HStack {
                    Text("Contacting host:")
                        .padding(.horizontal)
                    Spacer()
                    Text("\(userData.remoteHost)").foregroundColor(Clr.blue1).bold()
                }
                .padding(.all)
                VStack {
                    ForEach(self.dispData.rowItems()){ row in
                        ConnectViewRow(status: row.status, rowText: row.resp)
                    }
                }
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

