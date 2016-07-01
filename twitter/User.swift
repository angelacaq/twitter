//
//  User.swift
//  twitter
//
//  Created by Angela Chen on 6/27/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenname: NSString?
    var profileURL: NSURL?
    var tagline: NSString?
    var headerURL: NSURL?
    var followingCount: Double = 0
    var followerCount: Double = 0
    var tweetCount: Double = 0
    
    var dictionary: NSDictionary?
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let smallPhoto = dictionary["profile_image_url_https"] as? String
        let profileURLString = smallPhoto!.stringByReplacingOccurrencesOfString("_normal", withString: "")
        profileURL = NSURL(string: profileURLString)
        
        /*TwitterClient.sharedInstance.profileBanner(String(screenname!), success: { (URL: String) in
            headerURL = NSURL(string: URL)
        }) { (error: NSError) in
                print(error)
        }*/
        
        /*print("before header")
        let headerPhoto = dictionary["profile_background_image_url"] as? String
        headerURL = NSURL(string: headerPhoto!)*/
        
        followerCount = dictionary["followers_count"] as! Double
        followingCount = dictionary["friends_count"] as! Double
        tweetCount = dictionary["statuses_count"] as! Double
        tagline = dictionary["description"] as? String
    }
    
    class func getHeaderURL(user: User, success: (NSURL) -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.profileBanner(String(user.screenname!), success: { (URL: String) in
            success(NSURL(string: URL)!)
        }) { (error: NSError) in
            failure(error)
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
