//
//  Connect.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

struct Connect {
    static func getPingResponse(ipAddr: String) -> String {
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
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A view controller for testing SimplePing on iOS.
 */
/*
import UIKit

class MainViewController: UITableViewController, SimplePingDelegate {

    let hostName = "speedtest.kvant-telecom.ru"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.hostName
    }

    var pinger: SimplePing?
    var sendTimer: Timer?
    
    /// Called by the table view selection delegate callback to start the ping.
    
    func start(forceIPv4: Bool, forceIPv6: Bool) {
        self.pingerWillStart()

        NSLog("start")

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

    /// Called by the table view selection delegate callback to stop the ping.
    
    func stop() {
        NSLog("stop")
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
    
    
    

    // MARK: pinger delegate callback
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        NSLog("pinging %@", MainViewController.displayAddressForAddress(address: address as NSData))
        
        // Send the first ping straight away.
        
        self.sendPing()
        
        
        // And start a timer to send the subsequent pings.
        
        assert(self.sendTimer == nil)
        self.sendTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MainViewController.sendPing), userInfo: nil, repeats: true)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        NSLog("failed: %@", MainViewController.shortErrorFromError(error: error as NSError))
        
        self.stop()
    }
    
    var sentTime: TimeInterval = 0
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        sentTime = Date().timeIntervalSince1970
        NSLog("#%u sent", sequenceNumber)
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        NSLog("#%u send failed: %@", sequenceNumber, MainViewController.shortErrorFromError(error: error as NSError))
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        let some = Int(((Date().timeIntervalSince1970 - sentTime).truncatingRemainder(dividingBy: 1)) * 1000)
        print("PING: \(some) MS")
        NSLog("#%u received, size=%zu", sequenceNumber, packet.count)
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        NSLog("unexpected packet, size=%zu", packet.count)
    }
    
    // MARK: utilities
    
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
    
    // MARK: table view delegate callback
    
    @IBOutlet var forceIPv4Cell: UITableViewCell!
    @IBOutlet var forceIPv6Cell: UITableViewCell!
    @IBOutlet var startStopCell: UITableViewCell!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath)!
        switch cell {
        case forceIPv4Cell, forceIPv6Cell:
            cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        case startStopCell:
            if self.pinger == nil {
                let forceIPv4 = self.forceIPv4Cell.accessoryType != .none
                let forceIPv6 = self.forceIPv6Cell.accessoryType != .none
                self.start(forceIPv4: forceIPv4, forceIPv6: forceIPv6)
            } else {
                self.stop()
            }
        default:
            fatalError()
        }
        self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func pingerWillStart() {
        self.startStopCell.textLabel!.text = "Stop…"
    }
    
    func pingerDidStop() {
        self.startStopCell.textLabel!.text = "Start…"
    }
}
*/
