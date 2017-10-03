//
//  AutoAlertViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 10/2/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class AutoAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
