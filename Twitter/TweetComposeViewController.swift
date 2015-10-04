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
    
    @IBOutlet weak var tweetUserImageView: UIImageView!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetUserScreenNameLabel: UILabel!
    @IBOutlet weak var tweetBoxTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetUserImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        tweetUserNameLabel.text = User.currentUser!.name
        tweetUserScreenNameLabel.text = User.currentUser!.screenname
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var tweetDictionary = [String: String]()
        tweetDictionary["status"] = self.tweetBoxTextView.text
    
        TwitterClient.sharedInstance.postTweet(tweetDictionary) { (tweet, error) -> () in
            print("Back in tweetcomposeviewcontroller")
            if tweet == nil {
                print("Did not post tweet correctly")
            } else {
                print("Submitted new tweet")
                // View has a navigation controller
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
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
