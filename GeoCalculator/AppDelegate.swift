//
//  AppDelegate.swift
//  GeoCalculatorApp
//
//  Created by Cheng Li, Ryan Basso on 9/18/17.
//  Copyright © 2017 Cheng Li, Ryan Basso. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

let GOOGLE_PLACES_API_KEY = "AIzaSyD9mEL2-PNunUKU_jC4i3lbPxAXyQ_K0jo"
let DARK_SKY_WEATHER_API_KEY = "24c1b201c0a4a4f35fd4a43d7978c9aa"

let BACKGROUND_COLOR = UIColor.init(colorLiteralRed: 1.00, green: 0.325, blue:0.454, alpha:1.00)
let FOREGROUND_COLOR = UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue:1.0, alpha:1.00)


@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate, UIPickerViewDelegate, //SettingViewController {

    class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.statusBarStyle = UIStatusBarStyle.lightContent
        let navAppearance = UINavigationBar.appearance()
        navAppearance.barTintColor = BACKGROUND_COLOR
        navAppearance.tintColor = FOREGROUND_COLOR
        navAppearance.isTranslucent = false
        navAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        GMSPlacesClient.provideAPIKey(GOOGLE_PLACES_API_KEY)
        FirebaseApp.configure()
        
        
        
        // Override point for customization after application launch.
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

