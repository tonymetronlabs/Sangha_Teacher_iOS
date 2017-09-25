//
//  EventTableHeaderView.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/25/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var dateLabel: UILabel!

    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var headerViewHeight: CGFloat {
        return 30
    }
}
