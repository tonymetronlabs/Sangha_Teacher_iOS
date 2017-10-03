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
        // Dispose of any resources that can be recreated.
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
            
        }
        
        
        let navigationController = UINavigationController(rootViewController: navigateToViewController)
        
        navigationController.isBarTransparent = true
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
}
