//
//  ViewController.swift
//  SF Shuttle Tracker
//
//  Created by Joseph Smith on 1/19/16.
//  Copyright © 2016 bjoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CountdownDisplay {

    @IBOutlet weak var nearestShuttleLabel: UILabel!
    @IBOutlet weak var upcomingShuttlesTextView: UITextView!

    var shuttleTracker: ShuttleRoute?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shuttleTracker = ShuttleRoute(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateCountdown(nextShuttleTimes: [String]) {
        dispatch_async(dispatch_get_main_queue()) {
            if let nextShuttle = Int(nextShuttleTimes[0]) {
                if nextShuttle > 30 {
                    self.nearestShuttleLabel.textColor = UIColor.greenColor()
                }
                else if nextShuttle > 20 {
                    self.nearestShuttleLabel.textColor = UIColor.yellowColor()
                } else {
                    self.nearestShuttleLabel.textColor = UIColor.redColor()
                }
                self.nearestShuttleLabel.text = String(nextShuttleTimes[0]) + "min"
            }
            self.upcomingShuttlesTextView.text = nextShuttleTimes.joinWithSeparator("\n")
        }
    }

    func connectionError() {
        dispatch_async(dispatch_get_main_queue()) {
            self.upcomingShuttlesTextView.text = "Warning- connection error."
        }
    }
}

