//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Kevin Chen on 9/30/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
        }
        
        print("TWEETSSS: \(self.tweets)")
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        
    }
}
