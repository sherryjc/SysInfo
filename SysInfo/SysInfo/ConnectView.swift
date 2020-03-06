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
                Text("[FAIL] ").foregroundColor(Clr.red1)
                Text(rowText)
            }
        } else {
            return HStack {
                Text("[OK] ").foregroundColor(Clr.green1)
                Text(rowText)
            }
        }
    }
}

struct RowItem: Identifiable {
    var id : Int
    var status: ConnectStatus
    var resp: String
}


struct ConnectView: View {
    
    @EnvironmentObject private var userData : UserData
    
    init() {
        Connect.registerView(self)
    }
    
    func updateIpAddr(_ ipAddr: String) -> Void {
        userData.remoteIpAddr = ipAddr
    }
    
    func updateOutput(_ status: ConnectStatus, _ line: String) -> Void {
        var rows = userData.outputRows
        let currRows = rows.count
        let row = RowItem(id: currRows, status: status, resp: line)
        rows.append(row)
        print(rows.count)
        print("Appended row [\(row)], count=\(userData.outputRows.count)")
    }
    
    func hack() {
        // Add test rows
        self.updateIpAddr("192.168.0.1")
        // self.updateOutput(ConnectStatus.more, "Here is another line of text")
    }
    
    func clearOutput() -> Void {
        print("Clearing output")
        userData.outputRows = [RowItem]()
        print("Cleared output")
    }

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
                    TextField("Enter URL or IP address", text: $userData.remoteHost).padding(.all).border(Color.blue, width: 1.0).background(Clr.blue1).textFieldStyle(RoundedBorderTextFieldStyle())
                }
        
                HStack {
                    Button(action: {
                        if (!self.userData.remoteHost.isEmpty) {
                            self.clearOutput()
                            self.hack()
                            //Connect.ping(self.userData.remoteHost, 4)
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
                    Text("\(userData.remoteHost)").foregroundColor(Clr.red1)
                }
                .padding(.all)
                VStack {
                    Text("Row count: \(userData.outputRows.count)")
                    Text("Resolved IP Addr: \(userData.remoteIpAddr)")
                    List(userData.outputRows) { rowItem in
                        ConnectViewRow(status: rowItem.status, rowText: rowItem.resp)
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

