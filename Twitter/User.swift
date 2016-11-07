//
//  User.swift
//  Twitter
//
//  Created by Carina Boo on 10/29/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: Int?
    var name: String?
    var screenname: String?
//    private(set) var _screenname: String = ""
//    var screenname: String {
//        get {
//            return "@\(self._screenname)"
//        }
//        set {
//            self._screenname = newValue
//        }
//    }
    var profileURL: URL?
    var profileBackgroundURL: URL?
    var tagline: String?
    
    var tweetCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    
    var dictionary: NSDictionary?
    
    init(_ dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        let profileBackgroundURLString = dictionary["profile_banner_url"] as? String
        if let profileBackgroundURLString = profileBackgroundURLString {
            profileBackgroundURL = URL(string: profileBackgroundURLString)
        }
        
        tagline = dictionary["description"] as? String
        
        tweetCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
    }
    
    static let userDidLogoutNotificationName = NSNotification.Name(rawValue: "UserDidLogout")
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try!
                        JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try!
                    JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }

}
