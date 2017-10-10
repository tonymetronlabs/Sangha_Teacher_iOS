//
//  Utilities.swift
//  Sangha Teacher
//
//  Created by Balaji on 09/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    static let sharedInstance = Utilities()

    func logoutAction(viewController : UIViewController) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "SBLogin") as! LoginViewController
        let navCtrl = storyboard.instantiateViewController(withIdentifier: "SBNavCtrl") as! UINavigationController
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        AppDelegate.sharedInstance().window?.rootViewController = navCtrl
        AppDelegate.sharedInstance().window?.makeKeyAndVisible()
        viewController.navigationController?.popToRootViewController(animated: true)
        viewController.navigationController?.setViewControllers([loginVC], animated: true)
    }

    static var getJSONDecoderInstance : JSONDecoder {
        let instance = JSONDecoder()
        return instance
    }
}
