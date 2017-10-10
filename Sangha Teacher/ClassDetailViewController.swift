//
//  ClassDetailViewController.swift
//  Sangha Teacher
//
//  Created by Balaji on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ClassDetailViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var categoryHeaderCollectionView: UICollectionView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var listCollectionView: UICollectionView!

    var classID : String?
    var classDetailObj : ClassDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.listCollectionView.register(ClassListCells.CategoryHeaderCollectionViewCell.nib, forCellWithReuseIdentifier: ClassListCells.CategoryHeaderCollectionViewCell.cellIdentifier)
        self.listCollectionView.register(ClassListCells.CategoryListCollectionViewCell.nib, forCellWithReuseIdentifier: ClassListCells.CategoryListCollectionViewCell.cellIdentifier)

        self.fetchClassDetailAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - API

    func fetchClassDetailAPI() {

        let getClassDetailAPI = API.GetClassDetail.init(classID: self.classID!)

        APIHandler.sharedInstance.initWithAPIUrl(getClassDetailAPI.URL, method: getClassDetailAPI.APIMethod, params: getClassDetailAPI.param, currentView: self) { (success, response, data) in

        }

        APIHandler.sharedInstance.initWithAPIUrl(getClassDetailAPI.URL, method: getClassDetailAPI.APIMethod, params: getClassDetailAPI.param, currentView: self) { (success, responseDict, responseData) in

            if success {

                if responseDict!["status"] as? Int == 200 {

                    do {
                        self.classDetailObj = try? Utilities.getJSONDecoderInstance.decode(ClassDetail.self, from: responseData!)
                    }
                    catch {
                        
                    }
                }
            }
        }
    }
}

extension ClassDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryHeaderCollectionView {
            return 4
        }
        else {
            return 5
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell : UICollectionViewCell!

        if collectionView == categoryHeaderCollectionView {
            cell = ClassListCells.CategoryHeaderCollectionViewCell.cell(obj: collectionView, indexPath: indexPath) as! UICollectionViewCell
        }
        else {
            cell = ClassListCells.CategoryListCollectionViewCell.cell(obj: collectionView, indexPath: indexPath) as! UICollectionViewCell
        }

        return cell
    }
}
