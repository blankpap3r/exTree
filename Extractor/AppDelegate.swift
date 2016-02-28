//
//  AppDelegate.swift
//  Extractor
//
//  Created by Кирилл on 2/27/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: - Application delegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        User.initialize()
        Node.initialize()
        List.initialize()
        
        Parse.setApplicationId("K3iaNav9TphE8eopgbHoJUjWf7yNT5KGOsNG0Fb2",
            clientKey: "rVacb4z5iexRmUubmtdQtRY72KX2N0B6g5BuYQj3")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Push notifications
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Badge], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        if let launchOptions = launchOptions as? [String : AnyObject] {
            if let notificationDictionary = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject] {
                self.application(application, didReceiveRemoteNotification: notificationDictionary)
            }
        }
        
        tryToLoadMainApp()
        
        // Setup appearance
        configureView()
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // MARK: - Help methods
    func configureView() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 237/255.0, green: 174/255.0, blue: 47/255.0, alpha: 1)
        UINavigationBar.appearance().translucent  = false
        UINavigationBar.appearance().tintColor    = UIColor.whiteColor()
        
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName:            barFont
            ]
        }
    }
    
    // MARK: - Push notifications
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        if PFUser.currentUser() != nil {
            let installation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.setDeviceTokenFromData(deviceToken)
            installation.saveInBackground()
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        
        print(userInfo)
        
        NSNotificationCenter.defaultCenter().postNotificationName("refreshChatRoom", object: nil)
    }
    
    // MARK: - Global functions
    func tryToLoadMainApp() {
        if PFUser.currentUser() == nil {
            let loginVC = storyboard.instantiateInitialViewController()
            window?.rootViewController = loginVC
        } else {
            let mainVC = storyboard.instantiateViewControllerWithIdentifier("MainNavigationVC")
            window?.rootViewController = mainVC
        }
    }
    
    func logoutUser() {
        PFUser.logOutInBackgroundWithBlock {
            (error: NSError?) -> Void in
            if error != nil {
                print("Error occured while logging ")
                return
            }
            
            self.tryToLoadMainApp()
        }
    }

}

