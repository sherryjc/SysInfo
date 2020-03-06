//
//  Connect.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

struct Connect {
    
    static func getTestPingResponse(ipAddr: String) -> String {
        let retStr: String = """
        PING 10.0.0.1 (10.0.0.1): 56 data bytes
        64 bytes from 10.0.0.1: icmp_seq=0 ttl=64 time=4.364 ms
        64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=5.130 ms
        64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=4.921 ms
        64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=4.347 ms
        64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=4.349 ms
        64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=3.887 ms
        64 bytes from 10.0.0.1: icmp_seq=6 ttl=64 time=4.936 ms
        64 bytes from 10.0.0.1: icmp_seq=7 ttl=64 time=4.847 ms
        64 bytes from 10.0.0.1: icmp_seq=8 ttl=64 time=4.268 ms
        64 bytes from 10.0.0.1: icmp_seq=9 ttl=64 time=4.437 ms
        64 bytes from 10.0.0.1: icmp_seq=10 ttl=64 time=4.067 ms

        """
        return retStr
    }
    
    static func cb(_ status: ConnectStatus, _ response: String) -> Void {
        ConnectView.updateOutput(status, response)
    }
    
    static func ping(_ hostName: String, _ numPings: UInt8) {
        var pm = PingMgr(hostName: hostName,
                         numToSend: numPings,
                         callback: Connect.cb)
        pm.start(forceIPv4: true, forceIPv6: false)
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

class PingMgr: NSObject, SimplePingDelegate {
 
    // Inputs
    var hostName: String = ""
    var numToSend: UInt8 = 0
    var callback: (_ status: ConnectStatus, _ response: String) -> Void = {_,_ in }
    
    // System objects providing services
    var pinger: SimplePing?
    var sendTimer: Timer?
    
    // This PingMgr's bookkeeping
    var numSent: UInt8 = 0
    var numRecv: UInt8 = 0
    // Maps: seqNum -> Time sent
    var sentTimes = [UInt16 : TimeInterval]()

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

