//
//  AppDelegate.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/20/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        self.printFonts()

        self.setupInitialViewControllers()
        
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

    // MARK: - Methods

    class func sharedInstance() -> AppDelegate {
        let instance : AppDelegate = {
            let instance = AppDelegate()
            return instance
        }()
        return instance
    }

    func setupInitialViewControllers() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if UserDefaults.standard.value(forKey: UserDefaultsKey.isLogin.rawValue) == nil {
            UserDefaults.standard.set(false, forKey: UserDefaultsKey.isLogin.rawValue)
        }

        if UserDefaults.standard.bool(forKey: UserDefaultsKey.isLogin.rawValue) {

            let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "SBLeft") as! LeftSideMenuViewController
            let eventsViewController = storyboard.instantiateViewController(withIdentifier: "SBEvents") as! UINavigationController

            let sideMenuController = SlideMenuController(mainViewController: eventsViewController, leftMenuViewController: sideMenuVC)
            sideMenuController.addLeftGestures()

            API.accessToken = UserDefaults.standard.value(forKey: UserDefaultsKey.accessToken.rawValue) as! String

            self.window?.rootViewController = sideMenuController
            self.window?.makeKeyAndVisible()
        }
        else {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "SBLogin") as! LoginViewController
            let navCtrl = storyboard.instantiateViewController(withIdentifier: "SBNavCtrl") as! UINavigationController
            self.window?.rootViewController = navCtrl
            self.window?.makeKeyAndVisible()
        }
    }

    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
}

