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
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL,
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret)
    
    // Singleton pattern
//    class var sharedInstance: TwitterClient  {
//        struct Static {
//            static let instance = TwitterClient(baseURL: twitterBaseURL,
//                consumerKey: twitterConsumerKey,
//                consumerSecret: twitterConsumerSecret)
//        }
//        
//        return Static.instance
//    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation, response) -> Void in
            print("Home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            //                for tweet in tweets {
            //                    print("tweet: \(tweet.text), created: \(tweet.createdAt)")
            //                }
            }, failure: { (operation, error) -> Void in
                print("error getting current user")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        // Because this is a multi-step function, there is no way to 
        // loginCompletion holds closure until we're ready to use it.
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success:
            { (requestToken) -> Void in
                print("Success: \(requestToken.token)")
                
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
                
            }) { (requestTokenError) -> Void in
                print("Failed to get request token: \(requestTokenError)")
                self.loginCompletion?(user: nil, error: requestTokenError)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken) -> Void in
            
                print("Access Token Success: \(accessToken)")
                
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation, response) -> Void in
                        print("user: \(response)")
                        var user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        print("user is named \(user.name!)")
                        self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation, verifyCredentialsError) -> Void in
                        print("error: \(verifyCredentialsError)")
                        self.loginCompletion?(user: nil, error: verifyCredentialsError)
                })
                
//                TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil,
//                    success: { (operation, response) -> Void in
//                        print("Home timeline: \(response)")
//                        var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
//                        
//                        for tweet in tweets {
//                            print("tweet: \(tweet.text), created: \(tweet.createdAt)")
//                        }
//                        
//                }, failure: { (operation, error) -> Void in
//                        print("error getting current user")
//                })
            }, failure: { (homeTimelineError) -> Void in
                print("Failed to receive access tokens: \(homeTimelineError)")
                self.loginCompletion?(user: nil, error: homeTimelineError)
            })
    }
}
