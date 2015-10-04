//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Kevin Chen on 10/3/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {

    let tweetOriginalText = "Enter your tweet here."
    var tweetUserInputText = ""
    var tweet: Tweet!
    
    @IBOutlet weak var tweetUserImageView: UIImageView!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetUserScreenNameLabel: UILabel!
    @IBOutlet weak var tweetBoxTextView: UITextView!
    @IBOutlet weak var tweetCharCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetUserImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        tweetUserNameLabel.text = User.currentUser!.name
        tweetUserScreenNameLabel.text = User.currentUser!.screenname
        
        tweetBoxTextView.delegate = self
        
        if tweet == nil {
            print("ComposeVC came from TweetsVC")
        } else {
            print("ComposeVC came from TweetDetailsVC")
            tweetBoxTextView.text = (tweet.user?.screenname)! + " "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var tweetDictionary = [String: String]()
        tweetDictionary["status"] = self.tweetBoxTextView.text
    
        if tweet == nil {
            TwitterClient.sharedInstance.postTweet(tweetDictionary) { (tweet, error) -> () in
                print("Back in tweetcomposeviewcontroller")
                if tweet == nil {
                    print("Did not post tweet correctly")
    //                 tweets.prepend(tweet)
                } else {
                    print("Submitted new tweet")
                    // View has a navigation controller
                    // Shows tweetsViewController immediately after composing a tweet.
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
        else {
            let replyTweet = self.tweet
            let replyTweetText = "@" + (replyTweet.user?.screenname)! + self.tweetBoxTextView.text
            
            TwitterClient.sharedInstance.reply(self.tweetBoxTextView.text, tweet: replyTweet, completion: { (tweet, error) -> () in
                print("TweetComposeVC - Reply")
                if tweet == nil {
                    print("Did not reply correctly")
                } else {
                    print("Replied correctly")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            })
        }
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        // When user starts editing text, make the text empty.
        if tweet == nil {
            if tweetBoxTextView.text != nil {
                tweetBoxTextView.text = ""
            }
        }
        print("TweetBoxTextView:  \(tweetBoxTextView.text.characters.count)")
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        // Reset a tweet character count to the characters here.
        let characterCount = 140 - tweetBoxTextView.text.characters.count
        if characterCount < 0 {
            tweetCharCountLabel.textColor = UIColor.redColor()
        }
        tweetCharCountLabel.text = String(characterCount)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
