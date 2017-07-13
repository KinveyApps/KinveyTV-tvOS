//
//  AppDelegate.swift
//  KinveyTV
//
//  Created by Victor Hugo on 2017-07-11.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Kinvey.sharedClient.initialize(
            appKey: <#"My App Key"#>,
            appSecret: <#"My App Secret"#>
        ) { (result: Result<User?, Swift.Error>) in
            switch result {
            case .success(let user):
                if let user = user {
                    print("\(user)")
                } else {
                    self.signUp()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
        
        return true
    }
    
    func signUp() {
        User.signup() { (result: Result<User, Swift.Error>) in
            switch result {
            case .success(let user):
                print("\(user)")
            case .failure(let error):
                print("\(error)")
                let alert = UIAlertController(
                    title: "Error",
                    message: "Failure during login. Please try again.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "Try again",
                    style: .default,
                    handler: { (alertAction) in
                        alert.dismiss(animated: true) {
                            self.signUp()
                        }
                    }
                ))
                self.window?.rootViewController?.present(alert, animated: true)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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


}

