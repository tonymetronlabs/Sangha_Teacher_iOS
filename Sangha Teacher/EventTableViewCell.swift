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

    @IBOutlet weak var eventStatusVw: UIView!

    @IBOutlet weak var eventStatusStackVw: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func updateUI(with event: Event, selectedDate:Date) {

        self.eventTitleLabel.text = event.title

        // For demo we designed as staic

        let eventScheduleArr = event.computedSchedule?.calendar?.filter({ (eventCalendar) -> Bool in
            Calendar.current.isDate((eventCalendar.date?.toDateFromString(dateFormat: DateFormat.computedScheduleDate.rawValue))!, inSameDayAs: selectedDate)
        })

        if let eventSchedule = eventScheduleArr?.first, let startTime = eventSchedule.startTime, let endTime = eventSchedule.endTime {

            self.eventTimeLabel.isHidden = false
            self.eventTimeLabel.text = "\(startTime) - \(endTime)"
        }
        else {
            self.eventTimeLabel.isHidden = true
            self.eventTimeLabel.text = ""
        }

        if event.docSubType != nil {

            let type = EventType(rawValue: event.docSubType)!

            switch type {

            case .ptm:
                self.eventImageView.backgroundColor = UIColor.init(hex: 0xF2CF38)
                self.eventStatusVw.isHidden = true
                break

            case .fieldTrip:
                self.eventImageView.backgroundColor = UIColor.init(hex: 0x22B9F0)
                self.eventStatusVw.isHidden = false
                break

            case .reminder:
                self.eventImageView.backgroundColor = UIColor.init(hex: 0x53F9AE)
                self.eventStatusVw.isHidden = true
                break
            }

            self.eventTypeLabel.text = event.docSubType
        }

        if event.ais != nil {

            for aisObj in event.ais! {

                let type = AiType(rawValue: aisObj.aiType!)!

                let acceptCount = aisObj.acceptCount!
                let totalCount = aisObj.total!

                switch type {

                case .form:

                    self.formLabel.text = "F:\(acceptCount)/\(totalCount)"

                case .rsvp:

                    self.rsvpLabel.text = "R:\((acceptCount))/\(totalCount)"

                case .toBring:

                    self.toBringLabel.text = "B:\(acceptCount)/\(totalCount)"

                case .payment:

                    self.paymentLabel.text = "P:\(acceptCount)/\(totalCount)"

                case .volunteer:

                    self.volunteerLabel.text = "V:\(acceptCount)/\(totalCount)"

                case .ptm:
                    break
                }
            }
        }

        self.updateConstraintsIfNeeded()
        self.layoutIfNeeded()
    }

    class func getCellHeight(with event : Event, selectedDate : Date) -> CGFloat {

        let type = EventType(rawValue: event.docSubType)!

        var isTimeAvailable : Bool = false

        let eventScheduleArr =
            event.computedSchedule?.calendar?.filter({ (eventCalendar) -> Bool in
                Calendar.current.isDate((eventCalendar.date?.toDateFromString(dateFormat: DateFormat.computedScheduleDate.rawValue))!, inSameDayAs: selectedDate)
        })

        if let eventCalendar = eventScheduleArr?.first {
            isTimeAvailable = (!(eventCalendar.startTime?.isEmpty)! && !(eventCalendar.endTime?.isEmpty)!) ? true : false
        }

        switch type {
        case .fieldTrip:
            return isTimeAvailable ? 136 : 106
        case .reminder,.ptm:
            return isTimeAvailable ? 106 : 76
        default:
            return 0
        }
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
