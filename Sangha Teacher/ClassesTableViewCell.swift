//
//  ClassesTableViewCell.swift
//  Sangha Teacher
//
//  Created by Ezhil on 10/2/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ClassesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var cellHeight: CGFloat {
        return 100
    }
}
