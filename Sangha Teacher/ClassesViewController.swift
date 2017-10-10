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

    var classListModel : ClassList = ClassList()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.classesListTableView.register(ClassesTableViewCell.nib, forCellReuseIdentifier: ClassesTableViewCell.identifier)
        self.classesListTableView.tableFooterView = UIView()
        self.fetchAllClasses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- Button Action
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - API Call
    func fetchAllClasses() {

        let getAllClassesAPI = API.GetAllClasses()

        APIHandler.sharedInstance.initWithAPIUrl(getAllClassesAPI.URL, method: getAllClassesAPI.APIMethod, params: getAllClassesAPI.param, currentView: self) { (status, responseDict, responseData) in

            if status {

                let decoder = JSONDecoder()
                do{
                    self.classListModel = try decoder.decode(ClassList.self, from: responseData!)
                    self.classesListTableView.reloadData()
                }
                catch {

                }
            }
        }
    }
}

extension ClassesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.classListModel.classes.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassesTableViewCell.identifier) as! ClassesTableViewCell

        let classObj : Classes = self.classListModel.classes[indexPath.row]

        cell.classNameLabel.text = classObj.title
        cell.studentsCountLabel.text = "\(classObj.studentsCount) Students"

        tableView.tableFooterView = UIView()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let classID = self.classListModel.classes[indexPath.row]._id as? String {
            let classDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SBClassDetail") as! ClassDetailViewController
            classDetailVC.classID = classID
            self.navigationController?.pushViewController(classDetailVC, animated: true)
        }
    }
}
