//
//  Tweet.swift
//  Twitter
//
//  Created by Carina Boo on 10/29/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var creator: User?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(_ dictionary: NSDictionary) {
        let userDictionary = dictionary["user"] as? NSDictionary
        if let userDictionary = userDictionary {
            creator = User(userDictionary)
        }
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }
    
    class func tweets(from dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
