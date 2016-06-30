//
//  DetailsViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/29/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var tweet:Tweet!
    var now: NSDate = NSDate()
    
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        tweetLabel.text = String(tweet.text!)
        
        let username = tweet.user!.screenname
        usernameLabel.text = String("@\(username!)")
        screennameLabel.text = String(tweet.user!.name!)
        
        let timestamp = Tweet.timestampConverter(tweet.timestamp!, date2: now)
        dateLabel.text = timestamp
        
        if let url = tweet.user!.profileURL {
            if let imageView = avatarImageView {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            
            avatarImageView.setImageWithURL(url)
        }
        
        retweetCountLabel.text = String(tweet.retweetCount)
        if tweet.retweetCount == 1 {
            retweetLabel.text = "RETWEET"
        } else {
            retweetLabel.text = "RETWEETS"
        }
        
        if tweet.retweeted {
            retweetButton.setImage(UIImage(named: "retweetgreen1small"), forState: UIControlState.Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet1small"), forState: UIControlState.Normal)
        }
        
        likeCountLabel.text = String(tweet.favoriteCount)
        if tweet.favoriteCount == 1 {
            likeLabel.text = "LIKE"
        } else {
            likeLabel.text = "LIKES"
        }
        
        if tweet.favorited {
            heartButton.setImage(UIImage(named: "heartred1small"), forState: UIControlState.Normal)
        } else {
            heartButton.setImage(UIImage(named: "heart1small"), forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        let id = Int(tweet.id)
        
        TwitterClient.sharedInstance.retweet(tweet.retweeted, id: id, success: { (retweeted: Bool) in
            if retweeted {
                self.tweet.retweetCount += 1
                self.tweet.retweeted = true
            } else {
                self.tweet.retweetCount -= 1
                self.tweet.retweeted = false
            }
            self.viewDidLoad()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onFavoriteButton(sender: AnyObject) {
        let id = Int(tweet.id)
        TwitterClient.sharedInstance.favorite(tweet.favorited, id: id, success: { (favorited: Bool) in
            if favorited {
                self.tweet.favoriteCount += 1
                self.tweet.favorited = true
            } else {
                self.tweet.favoriteCount -= 1
                self.tweet.favorited = false
            }
            self.viewDidLoad()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
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
