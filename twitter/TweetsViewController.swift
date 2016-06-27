//
//  TweetsViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/27/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
            self.tweets = tweets
            
            for tweet in tweets {
                print(tweet.text)
            }
            
            self.tableView.reloadData()
            
        }) { (error: NSError) in
                print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
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
