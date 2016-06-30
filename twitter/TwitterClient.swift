//
//  TwitterClient.swift
//  twitter
//
//  Created by Angela Chen on 6/27/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "nQRWMOHu0PkyKxntrQLkDbZfc", consumerSecret: "SqGY2aZI2N79gLtEcwnyk7IHyxyHXpzwmDu2iloj2tQXFwdiRI")
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func userTweets(username: String, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(username)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func retweet(retweeted: Bool, id: Int, success: (Bool) -> (), failure: (NSError) -> ()) {
        if retweeted {
            let URL = String("1.1/statuses/unretweet/\(id).json")
            POST(URL, parameters: ["id": id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                success(false)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        } else {
            let URL = String("1.1/statuses/retweet/\(id).json")
            POST(URL, parameters: ["id": id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                success(true)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        }
    }
    
    func favorite(favorited: Bool, id: Int, success: (Bool) -> (), failure: (NSError) -> ()) {
        if favorited {
            let URL = String("1.1/favorites/destroy.json?id=\(id)")
            POST(URL, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                success(false)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        } else {
            let URL = String("1.1/favorites/create.json?id=\(id)")
            POST(URL, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                success(true)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        }
    }
    
    func tweet(tweet: String, success: () ->(), failure: (NSError) -> ()) {
        let URL = String("https://api.twitter.com/1.1/statuses/update.json?status=\(tweet)")
        let comboURL = URL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        POST(comboURL, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success()
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: (NSError ->())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth"), scope: nil, success: { (requestToken:
            BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:
            BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
            
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
}
