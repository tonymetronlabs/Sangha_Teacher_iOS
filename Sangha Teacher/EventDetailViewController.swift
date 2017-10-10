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

        self.tableView.register(EventListCells.EventImageTableViewCell.nib, forCellReuseIdentifier: EventListCells.EventImageTableViewCell.cellIdentifier)
        self.tableView.register(EventListCells.EventStatusTableViewCell.nib, forCellReuseIdentifier: EventListCells.EventStatusTableViewCell.cellIdentifier)
        self.tableView.register(EventListCells.EventDescriptionTableViewCell.nib, forCellReuseIdentifier: EventListCells.EventDescriptionTableViewCell.cellIdentifier)

        if let attachmentObj = self.eventObj?.attachments?.first, let _ = attachmentObj.url {
            cellArray.append(EventListCells.EventImageTableViewCell)
        }

        if self.eventObj?.klasses != nil, (self.eventObj?.klasses?.count)! > 0 {
            cellArray.append(EventListCells.EventClassesTableViewCell)
        }

        if self.eventObj?.stime != nil {
            cellArray.append(EventListCells.EventDateTimeTableViewCell)
        }

        if self.eventObj?.location?.address != nil {
            cellArray.append(EventListCells.EventLocationTableViewCell)
        }

        if self.eventObj?.desc != nil {
            cellArray.append(EventListCells.EventDescriptionTableViewCell)
        }

        if self.eventObj?.ais != nil {
            cellArray.append(EventListCells.EventStatusTableViewCell)
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
        var cell : UITableViewCell = cellType.cell(tableView: tableView)

        switch cellType {
        case .EventImageTableViewCell:
            (cell as? EventImageViewTableViewCell)?.loadContentView(event: self.eventObj!)
            break
        case .EventClassesTableViewCell:
            cell.textLabel?.text = "\((self.eventObj?.ais?.count)!) Classes"
            cell.imageView?.image = #imageLiteral(resourceName: "multi_profile")
            break
        case .EventDateTimeTableViewCell:
            cell.textLabel?.text = self.eventObj?.stime.toDateFromString(dateFormat: DateFormat.computedScheduleDate.rawValue).toString(dateFormat: DateFormat.eventDetailDate.rawValue)
            cell.imageView?.image = #imageLiteral(resourceName: "calender")
            break
        case .EventLocationTableViewCell:
            cell.imageView?.image = #imageLiteral(resourceName: "loc")
            cell.textLabel?.text = self.eventObj?.location != nil ? self.eventObj?.location?.address : ""
            break
        case .EventDescriptionTableViewCell:
            (cell as! EventDescriptionTableViewCell).loadContentView(event: self.eventObj!)
            break
        case .EventStatusTableViewCell:
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
        case .EventStatusTableViewCell:
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

    func didSelect(aisType: AiType, eventObj: Event) {
        print(aisType.rawValue + " --- " + eventObj.title)
    }
}
