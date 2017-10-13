//
//  ClassCategoryCollectionViewCell.swift
//  Sangha Teacher
//
//  Created by Balaji on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ClassCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadContentView(channelObj : Channel?) {
        if channelObj == nil {
            self.countLabel.text = "All"
            self.countLabel.textAlignment = .center
            self.categoryImageView.isHidden = true
        }
        else {
            self.countLabel.text = "\((channelObj?.parentsCount)!)"
            self.categoryImageView.image = channelObj?.channel?.image
        }
    }
}
