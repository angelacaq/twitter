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
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(query(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        query()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            print("count \(tweets.count)")
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
        let tweet = tweets![indexPath.row]
        
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
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
