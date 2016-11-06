//
//  AppDelegate.swift
//  Twitter
//
//  Created by Carina Boo on 10/28/16.
//  Copyright © 2016 Carina Boo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if User.currentUser != nil {
            print("there is a current user")
            
            // Go to Home screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
            window?.rootViewController = hamburgerViewController
            
//            let hamburgerViewController = window?.rootViewController as! HamburgerViewController
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
            
            hamburgerViewController.menuViewController = menuViewController
        } else {
            print("there is no user")
        }
        
        NotificationCenter.default.addObserver(forName: User.userDidLogoutNotificationName, object: nil, queue: OperationQueue.main) { (Notification) in
            // Go to Home screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("\(url.description)")
        
        TwitterClient.sharedInstance.handleOpenURL(url: url)
        
        return true
    }


}

