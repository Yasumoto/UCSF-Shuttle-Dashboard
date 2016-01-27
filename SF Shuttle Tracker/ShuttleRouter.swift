//
//  ShuttleRouter.swift
//  SF Shuttle Tracker
//
//  Created by Joseph Smith on 1/19/16.
//  Copyright © 2016 bjoli. All rights reserved.
//

import Foundation

protocol CountdownDisplay {
    func updateCountdown(countdown: [String])
    func connectionError()
}

class ShuttleRoute {
    var delegate: CountdownDisplay
    let session = NSURLSession.sharedSession()
    let goldZion = "https://apis.ucsf.edu/shuttle/predictions?routeId=gold&stopId=mtzion"

    init(delegate: CountdownDisplay) {
        self.delegate = delegate
        stopTimes()
        startQuery()
    }

    func startQuery() {
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(30), target: self, selector: Selector("stopTimes"), userInfo: nil, repeats: true)
    }

    @objc func stopTimes() {
        let task = session.dataTaskWithURL(NSURL(string: goldZion)!, completionHandler: self.receivedStopData)
        task.resume()
    }

    func receivedStopData(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void {
        if error != nil {
            NSLog((error?.debugDescription)!)
            return
        }
        do {
            if let jsonData = data {
                if let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.init(rawValue: 0)) as? NSDictionary {
                    if let times : NSArray = json.valueForKey("times") as? NSArray {
                        if times.count == 0 {
                            delegate.updateCountdown(["0"])
                        } else {
                            delegate.updateCountdown(times as! [String])
                            return
                        }
                    }
                }
            }
        } catch {
            delegate.connectionError()
        }
    }
}