//
//  TwitterClient.swift
//  Twitter
//
//  Created by Carina Boo on 10/29/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance: TwitterClient! = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: TwitterApp.consumerKey, consumerSecret: TwitterApp.consumerSecret)
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(userDictionary)
            
            print("name: \(user.name)")
            print("screen_name: \(user.screenname)")
            print("profile_image_url_https: \(user.profileURL)")
            print("description: \(user.tagline)")
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweets(from: dictionaries)
            
            for tweet in tweets {
                print("\(tweet.creator?.name): \(tweet.text)")
            }
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            
            failure(error)
        })
    }

}
