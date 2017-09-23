//
//  EventTableViewCell.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/22/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func updateUI(with event: Events) {
        
        self.eventTitleLabel.text = event.title
        self.eventTimeLabel.text = "08:00 AM - 9:00 AM"
        
        // For demo we designed as staic
        if event.docSubType == "ptm"{
            
            self.eventImageView.backgroundColor = UIColor.init(hex: 0xF2CF38)
            
        }else if event.docSubType == "fieldtrip" {
            
            self.eventImageView.backgroundColor = UIColor.init(hex: 0x22B9F0)
            
        }else if event.docSubType == "reminder" {
            
            self.eventImageView.backgroundColor = UIColor.init(hex: 0x53F9AE)
        }else{
            
            self.eventImageView.backgroundColor = UIColor.gray
        }
        
        self.eventTypeLabel.text = event.docSubType
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var cellHeight: CGFloat {
        return 90
    }
}
