//
//  ClassesViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 10/2/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ClassesViewController: UIViewController {

    @IBOutlet weak var classesListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.classesListTableView.register(ClassesTableViewCell.nib, forCellReuseIdentifier: ClassesTableViewCell.identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Button Action
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension ClassesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassesTableViewCell.identifier)
        
        return cell!
        
    }
}
