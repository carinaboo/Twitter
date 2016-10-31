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
        
        // Pull to refresh spinner
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Pull to Refresh
    func refreshControlAction(refreshControl:UIRefreshControl) {
        // Refresh tweets
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error:Error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        if let tweet = tweets?[indexPath.row] {
            cell.tweet = tweet
        }
        
        return cell
    }
    
    @IBAction func onLogOutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewTweet") {
            let tweetViewController = segue.destination as! TweetViewController
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let tweet = self.tweets?[(indexPath?.row)!]
            tweetViewController.tweet = tweet
        }
        if (segue.identifier == "ReplyToTweetFromHome") {
            let replyButton: UIButton = sender as! UIButton
            let cell = replyButton.superview?.superview as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let tweet = self.tweets?[(indexPath?.row)!]
            let newTweetViewController = segue.destination as! NewTweetViewController
            newTweetViewController.replyToTweet = tweet
        }
    }

}
