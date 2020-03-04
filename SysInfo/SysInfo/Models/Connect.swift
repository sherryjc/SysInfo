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
