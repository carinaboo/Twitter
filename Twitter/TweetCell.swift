//
//  TweetCell.swift
//  Twitter
//
//  Created by Carina Boo on 10/29/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            if let profileImageURL = tweet.creator?.profileURL {
                profileImageView.setImageWith(profileImageURL)
                profileImageView.layer.cornerRadius = 4.0;
                profileImageView.clipsToBounds = true;
            }
            nameLabel.text = tweet.creator?.name
            if let screenname = tweet.creator?.screenname {
                userNameLabel.text = "@\(screenname)"
            }
            messageLabel.text = tweet.text
            if let timestamp = tweet.timestamp {
                dateTimeLabel.text = dateString(for: timestamp)
            }
            updateActionButtons()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Updates the retweet, favorite, and reply button based on the tweet's current state.
    func updateActionButtons() {
        updateRetweetButton()
        
        updateFavoriteButton()
        
        let replyButtonImageView = replyButton.imageView
        replyButton.setImage(replyButtonImageView?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        replyButtonImageView?.tintColor = UIColor.gray
    }
    
    func updateRetweetButton() {
        let retweetButtonImageView = retweetButton.imageView
        retweetButton.setImage(retweetButtonImageView?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        if (tweet.retweeted) {
            retweetButtonImageView?.tintColor = UIColor.init(colorLiteralRed: 25.0/255.0, green: 207.0/255.0, blue: 134.0/255.0, alpha: 1.0) // mint green
        } else {
            retweetButtonImageView?.tintColor = UIColor.gray
        }
    }
    
    func updateFavoriteButton() {
        let favoriteButtonImageView = favoriteButton.imageView
        favoriteButton.setImage(favoriteButtonImageView?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        if (tweet.favorited) {
            favoriteButtonImageView?.tintColor = UIColor.init(colorLiteralRed: 226.0/255.0, green: 38.0/255.0, blue: 77.0/255.0, alpha: 1.0) // bright pink
        } else {
            favoriteButtonImageView?.tintColor = UIColor.gray
        }
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        print("Retweet")
        
        let retweet: Bool = !tweet.retweeted
        if retweet {
            // Retweet tweet
            self.tweet.retweeted = true
            self.tweet.retweetCount += 1
        } else {
            // Unretweet tweet
            self.tweet.retweeted = false
            self.tweet.retweetCount -= 1
        }
        updateRetweetButton()
        
        TwitterClient.sharedInstance.retweet(id: tweet.id!, retweet: retweet, success: { (tweet: Tweet) in
            print("retweeted")
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        print("Favorite")
        
        let favorite: Bool = !tweet.favorited
        if favorite {
            // Favorite tweet
            self.tweet.favorited = true
            self.tweet.favoritesCount += 1
        } else {
            // Unfavorite tweet
            self.tweet.favorited = false
            self.tweet.favoritesCount -= 1
        }
        updateFavoriteButton()
        
        TwitterClient.sharedInstance.favorite(id: tweet.id!, favorite: favorite, success: { (tweet: Tweet) in
            print("favorited")
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
        print("Reply")
    }
    
    func dateString(for dateTime: Date) -> String {
        let currentDateTime = Date()
        
        let calendar = Calendar.current
        let dateFlags: Set = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]
        let hourMinuteFlags: Set = [Calendar.Component.hour, Calendar.Component.minute]
        let currentDateComponents = calendar.dateComponents(dateFlags, from: currentDateTime)
        let dateComponents = calendar.dateComponents(dateFlags, from: dateTime)
        
        let currentDate = calendar.date(from: currentDateComponents)
        let date = calendar.date(from: dateComponents)
        
        if date! == currentDate! {
            // Show how many hours or minutes ago if within 24 hrs
            let currentTimeComponents = calendar.dateComponents(hourMinuteFlags, from: currentDateTime)
            let timeComponents = calendar.dateComponents(hourMinuteFlags, from: dateTime)
            let hourDifference = currentTimeComponents.hour! - timeComponents.hour!
            let minuteDifference = currentTimeComponents.minute! - timeComponents.minute!
            
            if hourDifference == 0 {
                // Show how many minutes ago if < 1 hr ago
                return "\(minuteDifference)m" // 6m
            } else if hourDifference == 1 && minuteDifference < 0 {
                return "\(60+minuteDifference)m" // 20m
            } else {
                // Show how many hours ago if > 1 hr ago
                return "\(hourDifference)h" // 3h
            }
        } else {
            // Show the date if older than 24 hrs
            let sameYearFormatter = DateFormatter()
            sameYearFormatter.dateFormat = "EEE MMM d" // Sat Oct 29
            
            let diffYearFormatter = DateFormatter()
            diffYearFormatter.dateFormat = "MMM d y" // Oct 29, 2015

            // Helpful explanation of date formatting:
            // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
            
            if dateComponents.year == currentDateComponents.year {
                return sameYearFormatter.string(from: dateTime)
            } else {
                return diffYearFormatter.string(from: dateTime)
            }
        }
    }

}
