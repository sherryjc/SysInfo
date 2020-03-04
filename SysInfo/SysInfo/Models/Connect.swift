//
//  Connect.swift
//  SysInfo
//
//  Created by loaner on 3/3/20.
//  Copyright © 2020 JMacDev. All rights reserved.
//

import Foundation

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
