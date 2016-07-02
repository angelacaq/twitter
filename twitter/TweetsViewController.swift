//
//  TweetsViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/27/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TTTAttributedLabelDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var now: NSDate?
    var isMoreDataLoading = false
    var queryLimit: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let image = UIImage(named: "mainicon2")
        self.navigationItem.titleView = UIImageView(image: image)
        self.navigationItem.titleView?.contentMode = .ScaleAspectFit
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
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
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        self.performSegueWithIdentifier("webSegue", sender: label)
        //UIApplication.sharedApplication().openURL(url)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
        let tweet = tweets![indexPath.row]
        cell.avatarButton.tag = indexPath.row
        
        cell.tweetLabel.text = String(tweet.text!)
        cell.tweetLabel.delegate = self
        
        let string = String(cell.tweetLabel.text!)
        if let http = string.rangeOfString("https") {
            let fromHTTP = string.substringFromIndex((http.startIndex))
            
            let indexOfSpace = fromHTTP.characters.indexOf(" ") ?? fromHTTP.endIndex
            let finalRange = fromHTTP.startIndex..<indexOfSpace
            let urlString = fromHTTP.substringWithRange(finalRange)
            
            let mainString = string as NSString
            let range = mainString.rangeOfString(urlString)
            let URL = NSURL(string: urlString)
            cell.tweetLabel.addLinkToURL(URL, withRange: range)
        }
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = (scrollViewContentHeight - tableView.bounds.size.height) * 0.8
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                
                // Code to load more results
                query()
            }
        }
    }
    
    func query(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance.homeTimeline(self.queryLimit, success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.now = NSDate()
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            if refreshControl == nil {
                 self.queryLimit += 20
            }
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            } else {
                self.isMoreDataLoading = false
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
            let tweet = tweets![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailsViewController
            detailViewController.tweet = tweet
            
        } else if segue.identifier == "webSegue" {
            let label = sender as! TTTAttributedLabel
            
            let detailViewController = segue.destinationViewController as! WebViewController
            
            let string = String(label.text!)
            if let http = string.rangeOfString("https") {
                let fromHTTP = string.substringFromIndex((http.startIndex))
                
                let indexOfSpace = fromHTTP.characters.indexOf(" ") ?? fromHTTP.endIndex
                let finalRange = fromHTTP.startIndex..<indexOfSpace
                let urlString = fromHTTP.substringWithRange(finalRange)
                detailViewController.URL = NSURL(string: urlString)
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
