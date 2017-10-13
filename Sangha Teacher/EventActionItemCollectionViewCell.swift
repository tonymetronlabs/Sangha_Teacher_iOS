//
//  EventActionItemCollectionViewCell.swift
//  Sangha Teacher
//
//  Created by Balaji on 12/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventActionItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var actionItemStackView: UIStackView!
    @IBOutlet weak var actionItemImageView: UIImageView!
    @IBOutlet weak var actionItemCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
