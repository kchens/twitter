//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Kevin Chen on 10/3/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
