//
//  TweetViewController.swift
//  Twitter
//
//  Created by Carina Boo on 10/30/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            if let profileImageURL = tweet.creator?.profileURL {
                profileImageView.setImageWith(profileImageURL)
            }
            nameLabel.text = tweet.creator?.name
            userNameLabel.text = tweet.creator?.screenname
            messageLabel.text = tweet.text
            if let timestamp = tweet.timestamp {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM d, y h:mm a" // Sat Oct 29, 2015 8:22 AM
                dateTimeLabel.text = formatter.string(from: timestamp)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
    }
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
