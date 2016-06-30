//
//  TweetsViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/27/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var now: NSDate?
    
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
        
        query()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func query(refreshControl: UIRefreshControl? = nil) {
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
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


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userSegue" {
            let button = sender as! UIButton
            let tweet = tweets![button.tag]
            
            let userViewController = segue.destinationViewController as! UserViewController
            userViewController.user = tweet.user
        } else if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.section]
            
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.tweet = tweet
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
