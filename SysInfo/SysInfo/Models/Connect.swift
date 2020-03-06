//
//  Connect.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation


struct Connect {
    
    static var cnView : ConnectView?
    static func registerView(_ cv: ConnectView) {
        cnView = cv
    }
    static func cb(_ status: ConnectStatus, _ response: String) -> Void {
        cnView?.updateOutput(status, response)
    }
    
    static func ping(_ hostName: String, _ numPings: UInt8) {
        let pm = PingMgrTest()
        pm.ping(hostName, numPings, Connect.cb)
    }
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

enum ConnectStatus {
    case success
    case fail
    case more
}

/*
class PingMgr: NSObject, SimplePingDelegate {
 
    // Inputs
    var hostName: String = ""
    var numToSend: UInt8 = 0
    typealias cbFunc = (ConnectStatus, String) -> Void
    var callback: cbFunc = {_,_ in }
    
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
        ConnectView.clearOutput()
    }
    
    func pingerDidStop() {
        self.clear()
    }

    // pinger delegate callbacks
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        let dispAddr = PingMgr.displayAddressForAddress(address: address as NSData)
        let resp = "Pinging host \(dispAddr)"
        callback(ConnectStatus.more, resp)
        
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
        self.callback(ConnectStatus.fail, errMsg)
        
        self.stop()
    }
    
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        let resp = "sent seq=\(sequenceNumber)"
        self.sentTimes[sequenceNumber] = Date().timeIntervalSince1970
        self.callback(ConnectStatus.more, resp)
        self.numSent += 1
        if (self.numSent >= self.numToSend) {
            // Stop the timer, no need to send any more
            self.sendTimer?.invalidate()
            self.sendTimer = nil
        }
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        let errMsg = PingMgr.shortErrorFromError(error: error as NSError)
        let resp = "send failed for seq=\(sequenceNumber) \(errMsg)"
        self.callback(ConnectStatus.fail, resp)
        self.stop()
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        let ms = Int(((Date().timeIntervalSince1970 - (sentTimes[sequenceNumber] ?? 0.0)).truncatingRemainder(dividingBy: 1)) * 1000)
        let resp = "received seq=\(sequenceNumber), sz=\(packet.count), time=\(ms) ms"
        numRecv += 1
        if (numRecv >= numToSend) {
            self.callback(ConnectStatus.success, resp)
            self.stop()
        } else {
            self.callback(ConnectStatus.more, resp)
        }
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        let resp = "received unexpected packet seq=??? sz=\(packet.count)"
        self.callback(ConnectStatus.more, resp)
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
*/

class PingMgrTest {
 
    // Inputs
    var hostName: String = ""
    var numToSend: UInt8 = 0
    typealias cbFunc = (ConnectStatus, String) -> Void
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
        let resp = "Pinging host \(ipAddr)"
        self.callback?(ConnectStatus.more, resp)
    }
    
    func gotDidFailWithError(_ errMsg: String) {
        self.callback?(ConnectStatus.fail, errMsg)
    }
    
    func gotDidSendPacket(_ sequenceNumber: UInt16) {
        let resp = "sent seq=\(sequenceNumber)"
        self.sentTimes[sequenceNumber] = Date().timeIntervalSince1970
        self.callback?(ConnectStatus.more, resp)
        self.numSent += 1
    }
    
    func gotDidFailToSendPacket(_ sequenceNumber: UInt16, _ errMsg: String) {
        let resp = "send failed for seq=\(sequenceNumber) \(errMsg)"
        self.callback?(ConnectStatus.fail, resp)
    }
    
    func gotDidReceiveResponsePacket(_ sequenceNumber: UInt16) {
        //et ms = Int(((Date().timeIntervalSince1970 - (sentTimes[sequenceNumber] ?? 0.0)).truncatingRemainder(dividingBy: 1)) * 1000)
        let ms = 4.1234
        let resp = "received seq=\(sequenceNumber), sz=64 time=\(ms) ms"
        numRecv += 1
        if (numRecv >= numToSend) {
            self.callback?(ConnectStatus.success, resp)
        } else {
            self.callback?(ConnectStatus.more, resp)
        }
    }

    func gotDidReceiveUnexpectedPacket() {
        let resp = "received unexpected packet seq=??? sz=64"
        self.callback?(ConnectStatus.more, resp)
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        let resp = "received unexpected packet seq=??? sz=64"
        self.callback?(ConnectStatus.more, resp)
    }
    
}

