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
        
//        deauthorize()
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
        homeTimeline(olderThan: 0, success: { (tweet: [Tweet]) in
            success(tweet)
        }) { (error: Error) in
            failure(error)
        }
    }
    
    // Gets tweets posted before / older than tweet |id| specified. If 0, ignores |id| param.
    func homeTimeline(olderThan id: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var params: [String:Any] = [
            "count": 20,
        ]
        if id > 0 {
            params["max_id"] = id
        }
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweets(from: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            
            failure(error)
        })
    }
    
    func userTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        userTimeline(userID: 0, olderThan: 0, success: { (tweet: [Tweet]) in
            success(tweet)
        }) { (error: Error) in
            failure(error)
        }
    }
    
    func userTimeline(userID: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        userTimeline(userID: userID, olderThan: 0, success: { (tweet: [Tweet]) in
            success(tweet)
        }) { (error: Error) in
            failure(error)
        }
    }
    
    // Gets user tweets posted before / older than tweet |id| specified. If 0, ignores |id| param.
    func userTimeline(userID: Int, olderThan tweetID: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var params: [String:Any] = [
            "count": 20
        ]
        if userID > 0 {
            params["user_id"] = userID
        }
        if tweetID > 0 {
            params["max_id"] = tweetID
        }
        get("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweets(from: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            
            failure(error)
        })
    }
    
    func mentionsTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        mentionsTimeline(olderThan: 0, success: { (tweet: [Tweet]) in
            success(tweet)
        }) { (error: Error) in
            failure(error)
        }
    }
    
    // Gets tweets posted before / older than tweet |id| specified. If 0, ignores |id| param.
    func mentionsTimeline(olderThan id: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var params: [String:Any] = [
            "count": 20,
        ]
        if id > 0 {
            params["max_id"] = id
        }
        get("1.1/statuses/mentions_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweets(from: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error: \(error.localizedDescription)")
            
            failure(error)
        })
    }
    
    func retweet(id: Int, retweet: Bool, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params: [String:Any] = [
            "id" : id
        ]
        if (retweet) {
            post("1.1/statuses/retweet/\(id).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let tweet = Tweet(response as! NSDictionary)
                success(tweet)
            }) { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        } else {
            post("1.1/statuses/unretweet/\(id).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let tweet = Tweet(response as! NSDictionary)
                success(tweet)
            }) { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        }
    }
    
    func favorite(id: Int, favorite: Bool, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params: [String:Any] = [
            "id" : id
        ]
        if (favorite) {
            post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let tweet = Tweet(response as! NSDictionary)
                success(tweet)
            }) { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        } else {
            post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let tweet = Tweet(response as! NSDictionary)
                success(tweet)
            }) { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        }
    }
    
    // Post a new tweet
    func post(status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params: [String:Any] = [
            "status" : status
        ]
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweet = Tweet(response as! NSDictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    // Reply to a tweet
    func reply(to id: Int, status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params: [String:Any] = [
            "in_reply_to_status_id": id,
            "status" : status
        ]
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweet = Tweet(response as! NSDictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }

}
