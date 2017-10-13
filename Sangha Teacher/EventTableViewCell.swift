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

    @IBOutlet weak var eventStatusCollectionView: UICollectionView!

    var event : Event?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.eventStatusCollectionView.register(EventActionItemCollectionViewCell.nib, forCellWithReuseIdentifier: EventActionItemCollectionViewCell.identifier)
//        self.eventStatusCollectionView.delegate = self
//        self.eventStatusCollectionView.dataSource = self
    }
    
    func updateUI(with event: Event, selectedDate:Date) {

        self.event = event

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

        guard let eventDocType = event.docSubType else {return}

        guard let type = EventType(rawValue: eventDocType) else {return}

        switch type {

        case .ptm:
            self.eventImageView.backgroundColor = UIColor.init(hex: 0xF2CF38)
            self.eventStatusCollectionView.isHidden = true
            break

        case .fieldTrip:
            self.eventImageView.backgroundColor = UIColor.init(hex: 0x22B9F0)
            self.eventStatusCollectionView.isHidden = false
            break

        case .reminder:
            self.eventImageView.backgroundColor = UIColor.init(hex: 0x53F9AE)
            self.eventStatusCollectionView.isHidden = true
            break
        }

        if let attachments = self.event?.attachments, attachments.count > 0, let url = attachments.first?.url {
            self.eventImageView.backgroundColor = UIColor.white
            self.eventImageView.pin_setImage(from: URL(string: url), placeholderImage: nil)
        }
        else {
            self.eventImageView.image = nil
        }

        self.eventTypeLabel.text = event.docSubType
        /*
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

 */
        DispatchQueue.main.async {
            self.eventStatusCollectionView.reloadData()
        }
//        self.layoutIfNeeded()
    }

    class func getCellHeight(with event : Event, selectedDate : Date) -> CGFloat {

        guard let eventDocType = event.docSubType, let type = EventType(rawValue: eventDocType) else {return 0}

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

extension EventTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let actionItems = event?.ais else {
            return 0
        }
        return actionItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: EventActionItemCollectionViewCell.identifier, for: indexPath) as! EventActionItemCollectionViewCell
        
        guard let actionItems = event?.ais else {
            return UICollectionViewCell()
        }

        let aisObj = actionItems[indexPath.row]

        guard let aiTypeStr = aisObj.aiType, let aiType = AiType(rawValue: aiTypeStr) else {
            return UICollectionViewCell()
        }

        cell.actionItemImageView.image = aiType.placeholderImageView
        guard let total = aisObj.total, let acceptCount = aisObj.acceptCount else
        {
            return UICollectionViewCell()
        }

        cell.actionItemCountLabel.text = aiType == AiType.payment ? "\(total)" : "\(acceptCount)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let actionItems = event?.ais else {
            return CGSize(width: collectionView.frame.size.width/5, height: collectionView.frame.size.height)
        }
        let size = collectionView.frame.size.width/5
        return CGSize(width: size, height: collectionView.frame.size.height)
    }
}
