//
//  EventDescriptionTableViewCell.swift
//  Sangha Teacher
//
//  Created by Ezhil on 04/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var eventDescLbl: UILabel!
    
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

    func loadContentView(event : Event) {
        self.eventDescLbl.text = event.desc
    }
}
