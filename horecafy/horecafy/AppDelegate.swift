//
//  AppDelegate.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 5/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Fabric
import Crashlytics

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var arrProductDistributor:[ProductObj] = []
    var arrDistributor:[DistributorObj] = []
    var arrOfferMaster:[OfferObject] = []
    
    class var sharedInstance: AppDelegate
    {
        struct Singleton
        {
            static let instance = AppDelegate()
        }
        return Singleton.instance
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.shared.enable = true
    
        Fabric.with([Crashlytics.self])
        
        if isRememberPressed == true
        {
            isLoggedIn = true
        }
        else
        {
            isLoggedIn = false
        }
        
//        if isLoggedIn {
//            let credentials = loadCredentials()
//            let mainSB = UIStoryboard(name: "main", bundle: nil)
//            if credentials.typeUser == .CUSTOMER {
//                let navigation = mainSB.instantiateViewController(withIdentifier: INITIAL) as! InitialViewController
//                self.window?.rootViewController = navigation
//            }
//            else {
//                let navigation = mainSB.instantiateViewController(withIdentifier: INITIAL_WHOLESALER) as! InitialWholeSalerViewController
//                self.window?.rootViewController = navigation
//            }
//        }
        
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


}

