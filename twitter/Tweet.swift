//
//  Tweet.swift
//  twitter
//
//  Created by Angela Chen on 6/27/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import AFDateHelper

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var user: User?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            timestamp = dateFormatter.dateFromString(timestampString)

            //print("now: \(dateFormatter.stringFromDate(now))")
        }
        
        let userDictionary = dictionary["user"] as! NSDictionary
        user = User(dictionary: userDictionary)
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favourites_count"] as? Int) ?? 0
    }
    
    class func timestampConverter(date1: NSDate, date2: NSDate) -> String {
        let minuteInSeconds: Int =  60
        let hourInSeconds: Int = 3600
        let dayInSeconds: Int = 86400
        let weekInSeconds: Int = 604800
        let yearInSeconds: Int = 31556926
        
        let calendar = NSCalendar.currentCalendar()
        let datecomponent = calendar.components(NSCalendarUnit.NSSecondCalendarUnit, fromDate: date1, toDate: date2, options: NSCalendarOptions.MatchStrictly)
        let seconds = datecomponent.second
        
        if seconds / yearInSeconds > 0 {
            return String("\(seconds / yearInSeconds)y")
        } else if seconds / weekInSeconds > 0 {
            return String("\(seconds / weekInSeconds)w")
        } else if seconds / hourInSeconds > 0 {
            return String("\(seconds / hourInSeconds)d")
        } else if seconds / dayInSeconds > 0 {
            return String("\(seconds / dayInSeconds)d")
        } else if seconds / minuteInSeconds > 0 {
            return String("\(seconds / minuteInSeconds)m")
        } else {
            return String("\(seconds)s")
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
        
    }

}

