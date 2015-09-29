//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kevin Chen on 9/29/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

let twitterConsumerKey = "wguyfhMI9OP0y74kfxQupoJy0"
let twitterConsumerSecret = "3AdRrjCtqRWHS2kJt85pN1Po2LvyCxLUBNgjpND1YVNIhoFKci"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
//    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL,
//        consumerKey: twitterConsumerKey,
//        consumerSecret: twitterConsumerSecret)
    
    class var sharedInstance: TwitterClient  {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
}
