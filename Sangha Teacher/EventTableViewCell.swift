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
    
    @IBOutlet weak var rsvpLabel: UILabel!
    
    @IBOutlet weak var volunteerLabel: UILabel!
    
    @IBOutlet weak var toBringLabel: UILabel!
    
    @IBOutlet weak var formLabel: UILabel!
    
    @IBOutlet weak var paymentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func updateUI(with event: Events) {
        
        self.eventTitleLabel.text = event.title
        
        
        
        // For demo we designed as staic
        self.eventTimeLabel.text = "08:00 AM - 9:00 AM"
        let type = EventType(rawValue: event.docSubType)!
        switch type {
        case .ptm:
            
            self.eventImageView.backgroundColor = UIColor.init(hex: 0xF2CF38)
            break
            
        case .fieldTrip:
            
            self.eventImageView.backgroundColor = UIColor.init(hex: 0x22B9F0)
            
            break
            
        case .reminder:
            
            self.eventImageView.backgroundColor = UIColor.init(hex: 0x53F9AE)
            
            break

        }
        
        self.eventTypeLabel.text = event.docSubType
        
        
        for aisObj in event.ais{
            
            let type = AiType(rawValue: aisObj.aiType)!
            
            switch type {
            
            case .form:
                
                let totalCount = (aisObj.summary?.acceptCount)!+(aisObj.summary?.pendingCount)!
                
                self.formLabel.text = "F:\((aisObj.summary?.acceptCount)!)/\(totalCount)"
                
            case .rsvp:
                
                let totalCount = (aisObj.summary?.acceptCount)!+(aisObj.summary?.rcap)!
                
                self.rsvpLabel.text = "R:\((aisObj.summary?.acceptCount)!)/\(totalCount)"
                
            case .toBring:
                
                let totalCount = (aisObj.summary?.acceptCount)!+(aisObj.summary?.pendingCount)!
                
                self.toBringLabel.text = "B:\((aisObj.summary?.acceptCount)!)/\(totalCount)"
                
            case .payment:
                
                self.paymentLabel.isHidden = false
                
                let totalCount = (aisObj.summary?.acceptCount)!+(aisObj.summary?.pendingCount)!
                
                self.paymentLabel.text = "P:\((aisObj.summary?.acceptCount)!)/\(totalCount)"
                
            case .voluenteer:
                
                let totalCount = (aisObj.summary?.acceptCount)!+(aisObj.summary?.pendingCount)!
                
                self.volunteerLabel.text = "V:\((aisObj.summary?.acceptCount!)!)/\(totalCount)"
             
            case .ptm:
                
                break
                
            }
            
        }
        
        
       /* approval
        approval
        approval
        approval
        rsvp
        approval
        rsvp
        todo
        stb
        approval
        approval
        approval
        rsvp
        rsvp
        rsvp
        stb
        todo
        approval
        payment
        ptm
        approval*/
        
        
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var cellHeight: CGFloat {
        return 116
    }
}
