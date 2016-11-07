//
//  ProfileCell.swift
//  Twitter
//
//  Created by Carina Boo on 11/6/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var namePageLeadingConstraint: NSLayoutConstraint!
    
    var user: User! {
        didSet {
            // Not actually the cover photos
//            if let profileBackgroundURL = user.profileBackgroundURL {
//                coverPhotoImageView.setImageWith(profileBackgroundURL)
//            }
            if let profileImageURL = user.profileURL {
                profileImageView.setImageWith(profileImageURL)
                profileImageView.layer.cornerRadius = 4.0;
                profileImageView.clipsToBounds = true;
            }
            nameLabel.text = user.name
            if let screenname = user.screenname {
                userNameLabel.text = "@\(screenname)"
            }
            tweetCountLabel.text = "\(user.tweetCount ?? 0)"
            followingCountLabel.text = "\(user.followingCount ?? 0)"
            followerCountLabel.text = "\(user.followerCount ?? 0)"
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

}
