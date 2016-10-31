//
//  TweetViewController.swift
//  Twitter
//
//  Created by Carina Boo on 10/30/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit
import AFNetworking

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
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load tweet details
        reloadData()
    }
    
    func reloadData() {
        if let profileImageURL = tweet.creator?.profileURL {
            profileImageView.setImageWith(profileImageURL)
        }
        nameLabel.text = tweet.creator?.name
        if let screenname = tweet.creator?.screenname {
            userNameLabel.text = "@\(screenname)"
        }
        messageLabel.text = tweet.text
        if let timestamp = tweet.timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d, y h:mm a" // Sat Oct 29, 2015 8:22 AM
            dateTimeLabel.text = formatter.string(from: timestamp)
        }
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoritesCount)"
        
        let retweetButtonImageView = retweetButton.imageView
        retweetButton.setImage(retweetButtonImageView?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        if (tweet.retweeted) {
            retweetButtonImageView?.tintColor = UIColor.init(colorLiteralRed: 25.0/255.0, green: 207.0/255.0, blue: 134.0/255.0, alpha: 1.0) // mint green
        } else {
            retweetButtonImageView?.tintColor = UIColor.gray
        }
        
        let favoriteButtonImageView = favoriteButton.imageView
        favoriteButton.setImage(favoriteButtonImageView?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        if (tweet.favorited) {
            favoriteButtonImageView?.tintColor = UIColor.init(colorLiteralRed: 226.0/255.0, green: 38.0/255.0, blue: 77.0/255.0, alpha: 1.0) // bright pink
        } else {
            favoriteButtonImageView?.tintColor = UIColor.gray
        }
        
        let replyButtonImageView = replyButton.imageView
        replyButton.setImage(replyButtonImageView?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        replyButtonImageView?.tintColor = UIColor.gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        print("Retweet")
        
        let retweet: Bool = !tweet.retweeted
        if retweet {
            // Retweet tweet
            self.tweet.retweeted = true
            self.tweet.retweetCount += 1
            retweetCountLabel.text = "\(self.tweet.retweetCount)"
        } else {
            // Unretweet tweet
            self.tweet.retweeted = false
            self.tweet.retweetCount -= 1
            retweetCountLabel.text = "\(self.tweet.retweetCount)"
        }
        TwitterClient.sharedInstance.retweet(id: tweet.id!, retweet: retweet, success: { (tweet: Tweet) in
            // API doesn't return most updated tweet that includes my favorite count
//            self.tweet = tweet
            self.reloadData()
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }

    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        print("Favorite")
        
        let favorite: Bool = !tweet.favorited
        // Update UI immediately, don't wait for API call to return
        if favorite {
            // Favorite tweet
            self.tweet.favorited = true
            self.tweet.favoritesCount += 1
            favoriteCountLabel.text = "\(self.tweet.favoritesCount)"
        } else {
            // Unfavorite tweet
            self.tweet.favorited = false
            self.tweet.favoritesCount -= 1
            favoriteCountLabel.text = "\(self.tweet.favoritesCount)"
        }
        TwitterClient.sharedInstance.favorite(id: tweet.id!, favorite: favorite, success: { (tweet: Tweet) in
            // API doesn't return most updated tweet that includes my favorite count
//            self.tweet = tweet
            self.reloadData()
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
        print("Reply")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReplyToTweet") {
            let newTweetViewController = segue.destination as! NewTweetViewController
            newTweetViewController.replyToTweet = tweet
        }
    }

}
