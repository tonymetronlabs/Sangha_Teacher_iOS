//
//  EventTitleTableViewCell.swift
//  Sangha Teacher
//
//  Created by Ezhil on 04/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventCommonLabelTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }
}
