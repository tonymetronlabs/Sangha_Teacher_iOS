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

    var animalsImagesArray : [UIImage] = [#imageLiteral(resourceName: "Bear"),#imageLiteral(resourceName: "Bird"),#imageLiteral(resourceName: "Camel"),#imageLiteral(resourceName: "Cat"),#imageLiteral(resourceName: "Crocodile"),#imageLiteral(resourceName: "Fish"),#imageLiteral(resourceName: "Dog"),#imageLiteral(resourceName: "Dolphin"),#imageLiteral(resourceName: "Duck"),#imageLiteral(resourceName: "Star"),#imageLiteral(resourceName: "Dove")]
    var animalsBGColors : [UInt32] = [0x26A95D, 0x7BC0BF, 0xD9BB41, 0xD88F78, 0x45ACA4, 0xD06A4D]
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

        cell.classImageView.backgroundColor = UIColor.init(hex: animalsBGColors[indexPath.row%animalsBGColors.count])
        cell.classImageView.image = animalsImagesArray[indexPath.row%animalsImagesArray.count]
        cell.classNameLabel.text = classObj.title
        cell.studentsCountLabel.text = "\(classObj.studentsCount) \(classObj.studentsCount > 1 ? "Students" : "Student")"

        tableView.tableFooterView = UIView()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedClassColor = UIColor.init(hex: animalsBGColors[indexPath.row%animalsBGColors.count])
        let selectedClassImage = animalsImagesArray[indexPath.row%animalsImagesArray.count]

        let classObj = self.classListModel.classes[indexPath.row] as Classes
        let classDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SBClassDetail") as! ClassDetailViewController
        classDetailVC.classColor = selectedClassColor
        classDetailVC.classImage = selectedClassImage
        classDetailVC.classObj = classObj
        self.navigationController?.pushViewController(classDetailVC, animated: true)
    }
}
