//
//  HomeViewController.swift
//  Twitter
//
//  Created by Carina Boo on 10/29/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Get initial tweets
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error:Error) in
            print("error: \(error.localizedDescription)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        if let tweet = tweets?[indexPath.row] {
            if let profileImageURL = tweet.creator?.profileURL {
                cell.profileImageView.setImageWith(profileImageURL)
            }
            cell.nameLabel.text = tweet.creator?.name
            cell.userNameLabel.text = tweet.creator?.screenname
            cell.messageLabel.text = tweet.text
        }
        
        return cell
    }
    
    @IBAction func onLogOutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
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
