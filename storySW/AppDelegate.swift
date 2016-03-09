//
//  AppDelegate.swift
//  storySW
//
//  Created by Tran Trung Tuyen on 20/01/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

import UIKit

let FONT_FAMILY_DEFAULT_KEY = "fontFamilyDefaultKey"
let READER_STYLE_DEFAULT_KEY = "readerStyleDefaultKey"

let GEORGIAKEY = 1
let TIMENEWROMANKEY = 2
let HELVETICAKEY = 3

let WHITESTYLE = 1
let BLACKSTYLE = 2
let SEPIASTYLY = 3

//helveticaButton

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = UIStatusBarStyle.LightContent

        let tabbar: UITabBarController = self.window?.rootViewController as! UITabBarController
        
//        UITabBar.appearance().shadowImage = UIImage()
//        
//        UITabBar.appearance().backgroundImage = UIImage()
        
//        UITabBar.appearance().barTintColor = UIColor.midnightBlueColor()
//        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        UITabBar.appearance().selectionIndicatorImage = UIImage.imageWithColor(UIColor.cloudsColor(), size: CGSizeMake((window?.screen.bounds.size.width)!/CGFloat((tabbar.tabBar.items?.count)!), 49))
        UITabBar.appearance().translucent = false
        
        self.removeTabbarItemText(tabbar)
        
        
        UINavigationBar.appearance().barTintColor        = UIColor(red: 0.31, green: 0.42, blue: 0.64, alpha: 1)
        UINavigationBar.appearance().translucent         = false;
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor           = UIColor.whiteColor()
        
        self.defaultReaderStyle()
        
        return true
    }
    
    func defaultReaderStyle(){
        let prefs = NSUserDefaults.standardUserDefaults()
        
        let fontSize = prefs.valueForKey("fontSize")
        if (fontSize == nil) { prefs.setFloat(14, forKey: "fontSize") }
        
        let fontFamily = prefs.stringForKey(FONT_FAMILY_DEFAULT_KEY)
        if (fontFamily == nil) { prefs.setValue(TIMENEWROMANKEY, forKey: FONT_FAMILY_DEFAULT_KEY)}
        
        let rStyle = prefs.valueForKey(READER_STYLE_DEFAULT_KEY)
        if (rStyle == nil) { prefs.setValue(WHITESTYLE, forKey: READER_STYLE_DEFAULT_KEY)}
    }
    
    func removeTabbarItemText(tabBar: UITabBarController) {
        if let items = tabBar.tabBar.items {
            var i = 0
            for item in items {
                if i == 0 {
//                    let view = item. as! UIView?
                    
                }
                item.title = ""
                item.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
                i++
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

