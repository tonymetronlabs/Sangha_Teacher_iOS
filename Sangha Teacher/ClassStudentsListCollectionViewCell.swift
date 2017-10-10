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

    override func awakeFromNib() {
        super.awakeFromNib()

        self.studentListTableView.register(ClassListCells.StudentListTableViewCell.nib, forCellReuseIdentifier: ClassListCells.StudentListTableViewCell.cellIdentifier)
    }
}
