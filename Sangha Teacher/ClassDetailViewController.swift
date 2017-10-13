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

    var classObj : Classes?
    var classDetailObj : Classes = Classes()
    var selectedIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    self.categoryHeaderCollectionView.register(ClassListCells.CategoryHeaderCollectionViewCell.nib, forCellWithReuseIdentifier: ClassListCells.CategoryHeaderCollectionViewCell.cellIdentifier)
        self.listCollectionView.register(ClassListCells.CategoryListCollectionViewCell.nib, forCellWithReuseIdentifier: ClassListCells.CategoryListCollectionViewCell.cellIdentifier)
        self.updateBottomLineView()
        self.fetchClassDetailAPI()

        let titleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        titleTextField.text = self.classObj?.title
        titleTextField.isUserInteractionEnabled = false
        titleTextField.textAlignment = .center
        titleTextField.sizeToFit()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = #imageLiteral(resourceName: "add")
        titleTextField.leftView = imageView
        titleTextField.leftViewMode = .always
        self.navigationItem.titleView = titleTextField
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    func updateBottomLineView() {
        self.bottomLineView.frame = CGRect(x: 0, y: self.headerView.frame.size.height-3, width: self.categoryHeaderCollectionView.frame.size.width/5, height: 3)
    }

    //MARK: - API

    func fetchClassDetailAPI() {

        let getClassDetailAPI = API.GetClassDetail.init(classID: (self.classObj?.id)!)

        APIHandler.sharedInstance.initWithAPIUrl(getClassDetailAPI.URL, method: getClassDetailAPI.APIMethod, params: getClassDetailAPI.param, currentView: self) { (success, responseDict, responseData) in

            if success {

                if responseDict!["status"] as? Int == 200 {

                    do {
                        let responseModel = try? Utilities.getJSONDecoderInstance.decode(ClassDetail.self, from: responseData!)
                        self.classDetailObj = (responseModel?.classObj)!
                        self.bottomLineView.isHidden = false
                        self.categoryHeaderCollectionView.reloadData()
                        self.listCollectionView.reloadData()
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension ClassDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let count = self.classDetailObj.summary?.counts?.count {
            return count + 1
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell : UICollectionViewCell!
        
        if collectionView == categoryHeaderCollectionView {
            cell = ClassListCells.CategoryHeaderCollectionViewCell.cell(obj: collectionView, indexPath: indexPath) as! ClassCategoryCollectionViewCell

            if indexPath.row == 0 {
                (cell as! ClassCategoryCollectionViewCell).loadContentView(channelObj: nil)
            }
            else {
                let index = indexPath.row - 1
                (cell as! ClassCategoryCollectionViewCell).loadContentView(channelObj: self.classDetailObj.summary?.counts![index])
            }
        }
        else {
            cell = ClassListCells.CategoryListCollectionViewCell.cell(obj: collectionView, indexPath: indexPath) as! ClassStudentsListCollectionViewCell
            (cell as! ClassStudentsListCollectionViewCell).studentListTableView.tableFooterView = UIView()
            var channel : Channel?
            if indexPath.row != 0 {
                guard let channelsArray = self.classDetailObj.summary?.counts else {return cell}
                channel = channelsArray[indexPath.row - 1]
            }
            (cell as! ClassStudentsListCollectionViewCell).loadContentView(classObj: self.classDetailObj, index: indexPath.row,channel: channel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if collectionView == categoryHeaderCollectionView {
            self.listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.categoryHeaderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        else {

        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryHeaderCollectionView {
            return CGSize(width: (collectionView.frame.size.width/5), height: collectionView.frame.size.height)
        }
        else {
            return collectionView.frame.size
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.bottomLineView.center = CGPoint(x:  self.bottomLineView.frame.size.width/2 + (scrollView.contentOffset.x/5), y: self.bottomLineView.center.y)

        let visibleRect = CGRect(origin: listCollectionView.contentOffset, size: listCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = listCollectionView.indexPathForItem(at: visiblePoint) else {return}
        selectedIndex = indexPath.row
    }
}
