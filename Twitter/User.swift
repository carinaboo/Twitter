//
//  User.swift
//  Twitter
//
//  Created by Carina Boo on 10/29/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class User: NSObject {
    
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
    var tagline: String?
    
    init(_ dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        screenname = dictionary["screen_name"] as? String
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        
        tagline = dictionary["description"] as? String
    }

}
