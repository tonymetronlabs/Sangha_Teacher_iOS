//
//  EventDetailViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 04/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

protocol SelectAisTypeDelegate {
    func didSelect(aisType : AiType, eventObj : Event)
}

class EventDetailViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!

    var cellArray : [EventListCells] = [EventListCells]()
    var eventObj : Event?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.headerView.headerLabel.text = self.eventObj?.title

        self.tableView.register(EventListCells.EventClassesTableViewCell.nib, forCellReuseIdentifier: EventListCells.EventClassesTableViewCell.cellIdentifier)
        self.tableView.register(EventListCells.EventImageTableViewCell.nib, forCellReuseIdentifier: EventListCells.EventImageTableViewCell.cellIdentifier)
        self.tableView.register(EventListCells.EventActionItemTableViewCell.nib, forCellReuseIdentifier: EventListCells.EventActionItemTableViewCell.cellIdentifier)
        self.tableView.register(EventListCells.EventDescTableViewCell.nib, forCellReuseIdentifier: EventListCells.EventDescTableViewCell.cellIdentifier)

        if let attachmentObj = self.eventObj?.attachments?.first, let _ = attachmentObj.url {
            cellArray.append(EventListCells.EventImageTableViewCell)
        }

        if self.eventObj?.klasses != nil {
            cellArray.append(EventListCells.EventClassesTableViewCell)
        }

        if self.eventObj?.startTime != nil {
            cellArray.append(EventListCells.EventDateTimeTableViewCell)
        }

        if self.eventObj?.location?.address != nil {
            cellArray.append(EventListCells.EventLocationTableViewCell)
        }

        if self.eventObj?.desc != nil {
            cellArray.append(EventListCells.EventDescTableViewCell)
        }

        if self.eventObj?.ais != nil {
            cellArray.append(EventListCells.EventActionItemTableViewCell)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
}

extension EventDetailViewController : UITableViewDataSource,UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellType = cellArray[indexPath.row]
        let cell : UITableViewCell = cellType.cell(tableView: tableView)

        switch cellType {
        case .EventImageTableViewCell:
            (cell as! EventImageViewTableViewCell).loadContentView(event: self.eventObj!)
            break
        case .EventClassesTableViewCell:
            guard let classes = self.eventObj?.klasses else {
                return UITableViewCell()}
            cell.textLabel?.text = classes.count > 0 ? "\(classes.count) Classes" : "All Classes"
            cell.imageView?.image = #imageLiteral(resourceName: "multi_profile")
            break
        case .EventDateTimeTableViewCell:
            cell.textLabel?.text = self.eventObj?.startTime.toDateFromString(dateFormat: DateFormat.computedScheduleDate.rawValue).toString(dateFormat: DateFormat.eventDetailDate.rawValue)
            cell.imageView?.image = #imageLiteral(resourceName: "calender")
            break
        case .EventLocationTableViewCell:
            cell.imageView?.image = #imageLiteral(resourceName: "loc")
            cell.textLabel?.text = self.eventObj?.location != nil ? self.eventObj?.location?.address : ""
            break
        case .EventDescTableViewCell:
            (cell as! EventDescriptionTableViewCell).loadContentView(event: self.eventObj!)
            break
        case .EventActionItemTableViewCell:
            (cell as! EventStatusTableViewCell).loadContentView(event: self.eventObj!)
            (cell as! EventStatusTableViewCell).delegate = self
            break
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cellType = cellArray[indexPath.row]

        switch cellType {
        case .EventClassesTableViewCell:
            
            break
        default:
            break
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let cellType = cellArray[indexPath.row]

        switch cellType {
        case .EventImageTableViewCell:
            guard let attachmentObj = self.eventObj?.attachments?.first, let _ = attachmentObj.url else {
                return 0
            }
            return 200
        case .EventActionItemTableViewCell:
            guard (self.eventObj?.ais) != nil else {
                return 0
            }
            var width = (tableView.frame.size.width - 40)/3
            width = width < 115 ? 115 : width
            return width * 2 + 10
        default:
            return UITableViewAutomaticDimension
        }
    }
}

extension EventDetailViewController : SelectAisTypeDelegate {

    func didSelect(aisType: AiType, eventObj: Event)
    {
        print(aisType.rawValue + " --- " + eventObj.title)
        
        let actionItemVC = self.storyboard?.instantiateViewController(withIdentifier: "ActionItemsViewController") as? ActionItemsViewController
        
        let actionItemNavigationCont = UINavigationController(rootViewController: actionItemVC!)
        
        actionItemVC?.selectedActionItem = aisType
        
        let aiTypeArray =  eventObj.ais?.map{ $0.aiType! }
        
        guard let aiTypes = aiTypeArray else { return }
        
        actionItemVC?.actionItemsArray = aiTypes
        actionItemVC?.eventsObj = eventObj
        actionItemNavigationCont.navigationBar.transparentBackground()
        
        self.present(actionItemNavigationCont, animated: true, completion: nil)
    }
}
