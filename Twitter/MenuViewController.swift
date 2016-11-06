//
//  MenuViewController.swift
//  Twitter
//
//  Created by Carina Boo on 11/5/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems: [String]?
    
    private var profileNavigationController: UIViewController!
    private var timelineNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuItems = ["Profile", "Timeline", "Mentions"]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Automatic cell height based on content
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Clear table background color
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
        
        // Set table height based on content
        tableView.sizeToFit()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationViewController")
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationViewController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationViewController")
        
        viewControllers.append(contentsOf: [profileNavigationController, timelineNavigationController, mentionsNavigationController])
        
        hamburgerViewController.contentViewController = timelineNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        
        if let menuItem = menuItems?[indexPath.row] {
            cell.title = menuItem
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
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
