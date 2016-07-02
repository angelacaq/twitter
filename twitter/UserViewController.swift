//
//  UserViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/29/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User?
    var tweets: [Tweet]?
    var now: NSDate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(query(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        if user == nil {
            TwitterClient.sharedInstance.currentAccount({ (account: User) in
                self.user = account
                self.setUI()
                self.query()
            }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        } else {
            self.setUI()
            query()
        }
    }
    
    func setUI() {
        let username = user!.screenname
        usernameLabel.text = String("@\(username!)")
        screennameLabel.text = String(user!.name!)
        descriptionLabel.text = String(user!.tagline!)
        
        followingCountLabel.text = countConversion(user!.followingCount)
        followerCountLabel.text = countConversion(user!.followerCount)
        tweetCountLabel.text = countConversion(user!.tweetCount)
        
        if let url = user!.profileURL {
            if let imageView = avatarImageView {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            avatarImageView.setImageWithURL(url)
            avatarImageView.layer.borderWidth = 3
            avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
        User.getHeaderURL(user!, success: { (url: NSURL) in
            if let imageView = self.headerImageView {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            self.headerImageView.setImageWithURL(url)
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
        
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        let retweetButton = sender as! UIButton
        let tweet = tweets![retweetButton.tag]
        let id = Int(tweet.id)
        
        TwitterClient.sharedInstance.retweet(tweet.retweeted, id: id, success: { (retweeted: Bool) in
            if retweeted {
                tweet.retweetCount += 1
                tweet.retweeted = true
            } else {
                tweet.retweetCount -= 1
                tweet.retweeted = false
            }
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onFavoriteButton(sender: AnyObject) {
        let favoriteButton = sender as! UIButton
        let tweet = tweets![favoriteButton.tag]
        let id = Int(tweet.id)
        
        TwitterClient.sharedInstance.favorite(tweet.favorited, id: id, success: { (favorited: Bool) in
            if favorited {
                tweet.favoriteCount += 1
                tweet.favorited = true
            } else {
                tweet.favoriteCount -= 1
                tweet.favorited = false
            }
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    func countConversion(value: Double) -> String {
        let MILLION = 1000000 as Double
        let THOUSAND = 1000 as Double
        
        if value / MILLION >= 1 {
            let newVal = NSString(format: "%.1fM", value / MILLION)
            return String(newVal)
        } else if value / THOUSAND >= 1 {
            let newVal = NSString(format: "%.1fK", value / THOUSAND)
            return String(newVal)
        } else {
            let newVal = NSString(format: "%.0f", value)
            return String(newVal)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTweetsTableViewCell", forIndexPath: indexPath) as! UserTweetsTableViewCell
        let tweet = tweets![indexPath.row]
        cell.avatarButton.tag = indexPath.row
        
        cell.tweetLabel.text = String(tweet.text!)
        
        let username = tweet.user!.screenname
        cell.usernameLabel.text = String("@\(username!)")
        
        cell.screenameLabel.text = String(tweet.user!.name!)
        
        let timestamp = Tweet.timestampConverter(tweet.timestamp!, date2: now!)
        cell.timestampLabel.text = timestamp
        
        if let url = tweet.user!.profileURL {
            if let imageView = cell.avatarImage {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            
            cell.avatarImage.setImageWithURL(url)
        }
        
        if tweet.retweetCount > 0 {
            cell.retweetCountLabel.text = String(tweet.retweetCount)
        } else {
            cell.retweetCountLabel.text = ""
        }
        
        if tweet.retweeted {
            cell.retweetButton.setImage(UIImage(named: "retweetgreen1small"), forState: UIControlState.Normal)
        } else {
            cell.retweetButton.setImage(UIImage(named: "retweet1small"), forState: UIControlState.Normal)
        }
        
        cell.retweetButton.tag = indexPath.row
        
        if tweet.favoriteCount > 0 {
            cell.favoriteCountLabel.text = String(tweet.favoriteCount)
        } else {
            cell.favoriteCountLabel.text = ""
        }
        
        if tweet.favorited {
            cell.favoriteButton.setImage(UIImage(named: "heartred1small"), forState: UIControlState.Normal)
        } else {
            cell.favoriteButton.setImage(UIImage(named: "heart1small"), forState: UIControlState.Normal)
        }
        
        cell.favoriteButton.tag = indexPath.row
        
        return cell
    }
    
    
    
    func query(refreshControl: UIRefreshControl? = nil) {
        
        let username = user!.screenname
        
        TwitterClient.sharedInstance.userTweets(String(username!), success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.now = NSDate()
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
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
