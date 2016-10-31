//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Carina Boo on 10/30/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Show current user's profile picture
        if let profileImageURL = User.currentUser?.profileURL {
            profileImageView.setImageWith(profileImageURL)
        }
        
        // Update character count as user types
        messageTextView.delegate = self
        updateCharacterCount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
    }
    
    func updateCharacterCount() {
        let characterCount = messageTextView.text?.characters.count
        characterCountLabel.text = "\(140 - characterCount!)"
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PostTweet") {
            let message = messageTextView.text ?? ""
            TwitterClient.sharedInstance.post(status: message, success: { (tweet: Tweet) in
                let homeViewController = segue.destination as! HomeViewController
                homeViewController.tweets?.insert(tweet, at: 0)
                homeViewController.tableView.reloadData()
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
            })
        }
    }

}
