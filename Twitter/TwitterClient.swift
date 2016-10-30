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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterly://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            if let requestToken = requestToken {
                let requestTokenString = requestToken.token ?? ""
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestTokenString)")!
                UIApplication.shared.openURL(url)
            }
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure!((error)!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotificationName, object: nil)
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        self.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(userDictionary)
            
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
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            
            failure(error)
        })
    }

}
