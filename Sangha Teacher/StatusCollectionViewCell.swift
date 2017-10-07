//
//  StatusCollectionViewCell.swift
//  Sangha Teacher
//
//  Created by Balaji on 07/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class StatusCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var circularSlider: MTCircularSlider!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryStatusCountLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
