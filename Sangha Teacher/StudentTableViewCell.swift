//
//  StudentTableViewCell.swift
//  Sangha Teacher
//
//  Created by Balaji on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var parentsCountLabel: UILabel!
    @IBOutlet weak var categoryStackView: UIStackView!

    @IBOutlet weak var mobileImageView: UIImageView!
    @IBOutlet weak var mailImageView: UIImageView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var callImageView: UIImageView!

    @IBOutlet weak var categorySlackViewWidthConstr: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
