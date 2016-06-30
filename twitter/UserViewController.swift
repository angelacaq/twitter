//
//  UserViewController.swift
//  twitter
//
//  Created by Angela Chen on 6/29/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    var user:User?
    
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
        
        if user == nil {
            TwitterClient.sharedInstance.currentAccount({ (account: User) in
                self.user = account
                print("whoops")
                self.setUI()
            }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        } else {
            self.setUI()
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
        
        if let url = user!.headerURL {
            if let imageView = headerImageView {
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
            }
            headerImageView.setImageWithURL(url)
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
