//
//  Connect.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

enum ConnectStatus {
    case unknown
    case success
    case fail
    case more
}

class RowItem: ObservableObject, Identifiable {
    var id : Int
    var status: ConnectStatus
    var resp: String
    
    init(_ id: Int, _ status: ConnectStatus, _ resp: String) {
        self.id = id
        self.status = status
        self.resp = resp
    }
 }

class RowItems: ObservableObject{
    @Published var items: [RowItem] = [RowItem]()

    func add(_ item: RowItem) {
        items.append(item)
    }
    
    func clear() {
        items = [RowItem]()
    }
    
    func count() -> Int {
        return items.count
    }
    
    func rowItems() -> [RowItem] {
        return items
    }
}

// This data comes back from external callbacks
class ConnectDispData: ObservableObject{
    @Published var remoteIpAddr: String = ""
    @Published var rows: RowItems = RowItems()
    
    func updateIpAddr(_ addr: String) -> Void {
        remoteIpAddr = addr
    }
    
    func addRow(_ st: ConnectStatus, _ resp: String) -> Void {
        let rowItem = RowItem(rows.count(), st, resp)
        rows.add(rowItem)
    }
    
    func clear() -> Void {
        rows.clear()
        remoteIpAddr = ""
    }
    
    func rowItems() -> [RowItem] {
        return rows.rowItems()
    }
}

struct Connect {
    
    static var connectDispData = ConnectDispData()
    
    static func cb(pr: PingResp) -> Void {
        if (pr.t == PingResp.opType.start && pr.st != ConnectStatus.fail) {
            connectDispData.clear()
            connectDispData.updateIpAddr(pr.txt)
            connectDispData.addRow(pr.st, "Resolved host to address " + pr.txt)
        } else {
            connectDispData.addRow(pr.st, pr.txt)
        }
    }

    static func ping(_ hostName: String, _ numPings: UInt8) {
        let pm = PingMgrTest()
        //let pm = PingMgr()
        pm.ping(hostName, numPings, Connect.cb)
    }
}

struct PingResp {
    enum opType {
        case start
        case send
        case recv
    }
    var st:     ConnectStatus
    var t:      opType
    var txt:    String
}

/*
var canStartPinging = false
The code that calls the ping:

let pinger = SimplePing(hostName: "www.apple.com")
pinger.delegate = self;
pinger.start()

do {
    if (canStartPinging) {
        pinger.sendPingWithData(nil)
    }
    NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture() as! NSDate)
} while(pinger != nil)
The SimplePing delegate method to wait for before you can start pinging:

func simplePing(pinger: SimplePing!, didStartWithAddress address: NSData!) {
    println("didStartWithAddress")
    canStartPinging = true
}
*/
/*
import UIKit
class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      self.checkIsConnectedToNetwork()
   }
   func checkIsConnectedToNetwork() {
      let hostUrl: String = "https://google.com"
      if let url = URL(string: hostUrl) {
         var request = URLRequest(url: url)
         request.httpMethod = "HEAD"
         URLSession(configuration: .default)
         .dataTask(with: request) { (_, response, error) -> Void in
            guard error == nil else {
               print("Error:", error ?? "")
               return
            }
            guard (response as? HTTPURLResponse)?
            .statusCode == 200 else {
               print("The host is down")
               return
            }
            print("The host is up and running")
         }
         .resume()
      }
   }
}
*/
/*
func myFunction() {
    let array = [Object]()
    let group = DispatchGroup() // initialize

    array.forEach { obj in

        // Here is an example of an asynchronous request which use a callback
        group.enter() // wait
        LogoRequest.init().downloadImage(url: obj.url) { (data) in
            if (data) {
                group.leave() // continue the loop
            }
        }
    }

    group.notify(queue: .main) {
        // do something here when loop finished
    }
}
*/
// This section based on the Apple sample program with the following copyright:
/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A view controller for testing SimplePing on iOS.
 */




class PingMgr: NSObject, SimplePingDelegate {
 
    // Inputs
    var hostName: String = ""
    var numToSend: UInt8 = 0
    typealias cbFunc = (PingResp) -> Void
    var callback: cbFunc?

    // System objects providing services
    var pinger: SimplePing?
    var sendTimer: Timer?
    
    // This PingMgr's bookkeeping
    var numSent: UInt8 = 0
    var numRecv: UInt8 = 0
    // Maps: seqNum -> Time sent
    var sentTimes = [UInt16 : TimeInterval]()
    
    func ping(_ host: String, _ num: UInt8, _ cb: @escaping cbFunc) {
        self.hostName = host
        self.numToSend = num
        self.callback = cb
        
        self.start(forceIPv4: true, forceIPv6: false)
    }

    func start(forceIPv4: Bool, forceIPv6: Bool) {
        
        self.pingerWillStart()

        let pinger = SimplePing(hostName: self.hostName)
        self.pinger = pinger

        // By default we use the first IP address we get back from host resolution (.Any)
        // but these flags let the user override that.
            
        if (forceIPv4 && !forceIPv6) {
            pinger.addressStyle = .icmPv4
        } else if (forceIPv6 && !forceIPv4) {
            pinger.addressStyle = .icmPv6
        }

        pinger.delegate = self
        print("Starting the pinger")
        pinger.start()
    }
    
    func stop() {
        self.pinger?.stop()
        self.pinger = nil

        self.sendTimer?.invalidate()
        self.sendTimer = nil
        
        self.pingerDidStop()
    }

    /// Sends a ping.
    ///
    /// Called to send a ping, both directly (as soon as the SimplePing object starts up) and
    /// via a timer (to continue sending pings periodically).
    
    @objc func sendPing() {
        self.pinger!.send(with: nil)
    }
    
    func clear() {
        self.numSent = 0
        self.numRecv = 0
        self.sentTimes = [UInt16 : TimeInterval]()
    }
    
    func pingerWillStart() {
        self.clear()
    }
    
    func pingerDidStop() {
        self.clear()
    }

    // pinger delegate callbacks
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        print("Got callback: didStartWithAddress")
        let ipAddr = PingMgr.displayAddressForAddress(address: address as NSData)
        let pr = PingResp(st: ConnectStatus.more, t: PingResp.opType.start, txt: ipAddr)
        self.callback?(pr)

        // Send the first ping straight away.
        self.sendPing()
        assert(self.numSent == 0)
        self.numSent += 1
        
        if self.numSent < self.numToSend {
            // Start a timer to send the subsequent pings.
            assert(self.sendTimer == nil)
            self.sendTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PingMgr.sendPing), userInfo: nil, repeats: true)
        }
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        let errMsg = PingMgr.shortErrorFromError(error: error as NSError)
        let pr = PingResp(st: ConnectStatus.fail, t: PingResp.opType.start, txt: errMsg)
        self.callback?(pr)
        self.stop()
    }
    
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        let resp = "sent seq=\(sequenceNumber)"
        self.sentTimes[sequenceNumber] = Date().timeIntervalSince1970
        let pr = PingResp(st: ConnectStatus.more, t: PingResp.opType.send, txt: resp)
        self.callback?(pr)
        self.numSent += 1
        if (self.numSent >= self.numToSend) {
            // Stop the timer, we are done sending
            self.sendTimer?.invalidate()
            self.sendTimer = nil
        }
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        let errMsg = PingMgr.shortErrorFromError(error: error as NSError)
        let resp = "send failed for seq=\(sequenceNumber) \(errMsg)"
        let pr = PingResp(st: ConnectStatus.fail, t: PingResp.opType.send, txt: resp)
        self.callback?(pr)
        self.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        let ms = Int(((Date().timeIntervalSince1970 - (sentTimes[sequenceNumber] ?? 0.0)).truncatingRemainder(dividingBy: 1)) * 1000)
        let resp = "received seq=\(sequenceNumber), sz=\(packet.count), time=\(ms) ms"
        numRecv += 1
        if (numRecv >= numToSend) {
            let pr = PingResp(st: ConnectStatus.success, t: PingResp.opType.send, txt: resp)
            self.callback?(pr)
            self.stop()
        } else {
            let pr = PingResp(st: ConnectStatus.more, t: PingResp.opType.send, txt: resp)
            self.callback?(pr)
        }
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        let resp = "received unexpected packet seq=??? sz=\(packet.count)"
        let pr = PingResp(st: ConnectStatus.more, t: PingResp.opType.send, txt: resp)
        self.callback?(pr)
    }
    
    // Utilities
    
    /// Returns the string representation of the supplied address.
    ///
    /// - parameter address: Contains a `(struct sockaddr)` with the address to render.
    ///
    /// - returns: A string representation of that address.

    static func displayAddressForAddress(address: NSData) -> String {
        var hostStr = [Int8](repeating: 0, count: Int(NI_MAXHOST))
        
        let success = getnameinfo(
            address.bytes.assumingMemoryBound(to: sockaddr.self),
            socklen_t(address.length),
            &hostStr,
            socklen_t(hostStr.count),
            nil,
            0,
            NI_NUMERICHOST
        ) == 0
        let result: String
        if success {
            result = String(cString: hostStr)
        } else {
            result = "?"
        }
        return result
    }

    /// Returns a short error string for the supplied error.
    ///
    /// - parameter error: The error to render.
    ///
    /// - returns: A short string representing that error.

    static func shortErrorFromError(error: NSError) -> String {
        if error.domain == kCFErrorDomainCFNetwork as String && error.code == Int(CFNetworkErrors.cfHostErrorUnknown.rawValue) {
            if let failureObj = error.userInfo[kCFGetAddrInfoFailureKey as String] {
                if let failureNum = failureObj as? NSNumber {
                    if failureNum.intValue != 0 {
                        let f = gai_strerror(Int32(failureNum.intValue))
                        if f != nil {
                            return String(cString: f!)
                        }
                    }
                }
            }
        }
        if let result = error.localizedFailureReason {
            return result
        }
        return error.localizedDescription
    }
    
}


class PingMgrTest {
 
    // Inputs
    var hostName: String = ""
    var numToSend: UInt8 = 0
    typealias cbFunc = (PingResp) -> Void
    var callback: cbFunc?
    
    // This PingMgr's bookkeeping
    var numSent: UInt8 = 0
    var numRecv: UInt8 = 0
    // Maps: seqNum -> Time sent
    var sentTimes = [UInt16 : TimeInterval]()
    
    func ping(_ host: String, _ num: UInt8, _ cb: @escaping cbFunc) {
        self.hostName = host
        self.numToSend = num
        self.callback = cb
        
        self.start(forceIPv4: true, forceIPv6: false)
    }

    func start(forceIPv4: Bool, forceIPv6: Bool) {
        
        self.pingerWillStart()
        
        self.simulate("192.168.0.1")

        self.stop()
        
    }
    
    func simulate(_ ipAddr: String) {
        self.gotDidStartWithAddress(ipAddr)
        self.gotDidSendPacket(0)
        self.gotDidReceiveResponsePacket(0)
        self.gotDidSendPacket(1)
        self.gotDidReceiveResponsePacket(1)
        self.gotDidSendPacket(2)
        self.gotDidReceiveResponsePacket(2)
        self.gotDidSendPacket(3)
        self.gotDidReceiveResponsePacket(3)

    }
    
    func stop() {
        self.pingerDidStop()
    }
    
    func clear() {
        self.numSent = 0
        self.numRecv = 0
        self.sentTimes = [UInt16 : TimeInterval]()
    }
    
    func pingerWillStart() {
        self.clear()
    }
    
    func pingerDidStop() {
        self.clear()
    }

    // simulated pinger delegate callbacks
    func gotDidStartWithAddress(_ ipAddr: String) {
        let pr = PingResp(st: ConnectStatus.more, t: PingResp.opType.start, txt: ipAddr)
        self.callback?(pr)
    }
    
    func gotDidFailWithError(_ errMsg: String) {
        let pr = PingResp(st: ConnectStatus.fail, t: PingResp.opType.start, txt: errMsg)
        self.callback?(pr)
    }
    
    func gotDidSendPacket(_ sequenceNumber: UInt16) {
        let resp = "sent seq=\(sequenceNumber)"
        self.sentTimes[sequenceNumber] = Date().timeIntervalSince1970
        let pr = PingResp(st: ConnectStatus.more, t: PingResp.opType.send, txt: resp)
        self.callback?(pr)
        self.numSent += 1
    }
    
    func gotDidFailToSendPacket(_ sequenceNumber: UInt16, _ errMsg: String) {
        let resp = "send failed for seq=\(sequenceNumber) \(errMsg)"
        let pr = PingResp(st: ConnectStatus.fail, t: PingResp.opType.send, txt: resp)
        self.callback?(pr)
    }
    
    func gotDidReceiveResponsePacket(_ sequenceNumber: UInt16) {
        //et ms = Int(((Date().timeIntervalSince1970 - (sentTimes[sequenceNumber] ?? 0.0)).truncatingRemainder(dividingBy: 1)) * 1000)
        let ms = 4.1234
        let resp = "received seq=\(sequenceNumber), sz=64 time=\(ms) ms"
        numRecv += 1
        var st = ConnectStatus.more
        if (numRecv >= numToSend) {
            st = ConnectStatus.success
        }
        let pr = PingResp(st: st, t: PingResp.opType.recv, txt: resp)
        self.callback?(pr)
    }

    func gotDidReceiveUnexpectedPacket() {
        let resp = "received unexpected packet seq=??? sz=64"
        let pr = PingResp(st: ConnectStatus.more, t: PingResp.opType.recv, txt: resp)
        self.callback?(pr)
    }
}

