//
//  ClassStudentsListCollectionViewCell.swift
//  Sangha Teacher
//
//  Created by Balaji on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ClassStudentsListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var studentListTableView: UITableView!

    var currentIndex : Int?
    var studentsArray = [Student]()
    var channelObj : Channel?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.studentListTableView.register(ClassListCells.StudentListTableViewCell.nib, forCellReuseIdentifier: ClassListCells.StudentListTableViewCell.cellIdentifier)
    }

    func loadContentView(classObj : Classes, index : Int, channel : Channel?) {
        currentIndex = index

        if currentIndex == 0 {
            if let students = classObj.students {
                studentsArray = students
            }
        }
        else {
            guard let channelsArray = classObj.summary?.counts, channelsArray.count > 0 else {return}
            channelObj = channelsArray[currentIndex! - 1]

            let studentChannelArr = classObj.students?.map({ (studentObj) -> Student? in

                let parents = studentObj.parents?.filter{$0.channel == channelObj?.channel}

                guard let parentArr = parents, parentArr.count > 0 else { return nil }
                return studentObj

            }).filter{$0 != nil}

            guard let studArray = studentChannelArr! as? [Student] else {
                return
            }
            studentsArray = studArray
        }
        self.studentListTableView.reloadData()
    }

    fileprivate func getAllParentChannels(studentObj : Student) -> Set<ChannelType>? {
        let channelArray = studentObj.parents?.map{$0.channel}
        guard let array = channelArray as? [ChannelType] else {return nil}
        return Set(array)
    }
}

extension ClassStudentsListCollectionViewCell : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = ClassListCells.StudentListTableViewCell.cell(obj: tableView, indexPath: indexPath) as! StudentTableViewCell

        let studentObj = studentsArray[indexPath.row]

        guard let firstLetter = studentObj.firstName.uppercased().characters.first, let secondLetter = studentObj.lastName.uppercased().characters.first else {
            return cell
        }

        cell.studentNameLabel.text = studentObj.firstName + " " + studentObj.lastName
        if let parents = studentObj.parents {
            cell.parentsCountLabel.text = parents.count <= 1 ? "\(parents.count) Parent" : "\(parents.count) Parents"
        }
        else {
            cell.parentsCountLabel.text = "0 Parent"
        }

        cell.profileButton.setTitle("\(firstLetter)\(secondLetter)", for: .normal)
        cell.chatImageView.isHidden = true
        cell.mailImageView.isHidden = true
        cell.callImageView.isHidden = true
        cell.mobileImageView.isHidden = true

        if currentIndex == 0 {
            guard let channelsSet = self.getAllParentChannels(studentObj: studentObj) else {
                cell.categorySlackViewWidthConstr.constant = 0
                cell.layoutIfNeeded()
                return cell
            }
            cell.categorySlackViewWidthConstr.constant = CGFloat(channelsSet.count * 20)

            for channel in channelsSet {

                switch channel {
                case .app:
                    cell.chatImageView.isHidden = false
                    break
                case .email:
                    cell.mailImageView.isHidden = false
                    break
                case .landline:
                    cell.callImageView.isHidden = false
                    break
                default:
                    cell.mobileImageView.isHidden = false
                    break
                }
            }
        }
        else {
            cell.categorySlackViewWidthConstr.constant = 0

            let filteredArray = studentObj.parents?.filter{
                $0.channel == channelObj?.channel
            }

            guard let currentChannelParentsArray = filteredArray else {return cell}

            cell.parentsCountLabel.text = currentChannelParentsArray.count > 1 ? "\(currentChannelParentsArray.count) Parents" : "\(currentChannelParentsArray.count) Parent"
        }
        cell.layoutIfNeeded()
        tableView.tableFooterView = UIView()

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
