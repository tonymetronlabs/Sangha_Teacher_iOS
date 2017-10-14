//
//  LeftSideMenuViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/27/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension LeftSideMenuViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuItem.menuArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        
        let menuItem = MenuItem.menuArray[indexPath.row]
        
        let titleLabel = cell?.viewWithTag(1) as! UILabel
        titleLabel.text = menuItem.menuTitle
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        slideMenuController()?.closeLeft()
        
        var navigateToViewController = UIViewController()
        
        let menuItem = MenuItem.menuArray[indexPath.row]
        
        switch menuItem {
        case .notifications:
            
             navigateToViewController = self.storyboard?.instantiateViewController(withIdentifier: "SBNotifications") as! NotificationsViewController
            
        case .autoAlert:
            
            navigateToViewController = self.storyboard?.instantiateViewController(withIdentifier: "SBAutoAlert") as! AutoAlertViewController
            
            
        case .classes:
            
            navigateToViewController = self.storyboard?.instantiateViewController(withIdentifier: "SBClasses") as! ClassesViewController
            
            
            
        case .settings:
            
           navigateToViewController = self.storyboard?.instantiateViewController(withIdentifier: "SBSettings") as! SettingsViewController

        case .logout:

            let alertController = UIAlertController(title: "Confirm Logout", message: "Are you sure want to Logout?", preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive, handler: { (alertAction) in
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "SBLogin") as! LoginViewController
                let navCtrl = self.storyboard?.instantiateViewController(withIdentifier: "SBNavCtrl") as! UINavigationController
                if let bundle = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundle)
                }
                AppDelegate.sharedInstance().window?.rootViewController = navCtrl
                AppDelegate.sharedInstance().window?.makeKeyAndVisible()
                ((self.parent as! SlideMenuController).mainViewController as! UINavigationController).popToRootViewController(animated: true)
                ((self.parent as! SlideMenuController).mainViewController as! UINavigationController).setViewControllers([loginVC], animated: true)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alertController.addAction(logoutAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)

            return
        }
        
        let navigationController = UINavigationController(rootViewController: navigateToViewController)
        
        navigationController.isBarTransparent = true
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
}
