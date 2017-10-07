//
//  EventDetailViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 04/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!

    var eventObj : Event?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.headerView.headerLabel.text = self.eventObj?.title
        self.tableView.register(UINib(nibName: "EventStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "eventStatusTableViewCell")
        self.tableView.register(UINib(nibName: "EventImageViewTableViewCell", bundle: nil), forCellReuseIdentifier: "eventDetailImageViewCell")
        self.tableView.register(UINib(nibName: "EventDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "eventDetailDescriptionCell")
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
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : UITableViewCell!

        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier:"eventDetailImageViewCell")
            (cell as? EventImageViewTableViewCell)?.loadContentView(event: self.eventObj!)
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell.textLabel?.text = self.eventObj?.owner
            cell.imageView?.image = #imageLiteral(resourceName: "multi_profile")
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell.textLabel?.text = self.eventObj?.stime.toDateFromString(dateFormat: DateFormat.computedScheduleDate.rawValue).toString(dateFormat: DateFormat.eventDetailDate.rawValue)
            cell.imageView?.image = #imageLiteral(resourceName: "calender")
            break
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell.imageView?.image = #imageLiteral(resourceName: "loc")
            cell.textLabel?.text = self.eventObj?.location != nil ? self.eventObj?.location?.address : ""
            break
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "eventDetailDescriptionCell")
            (cell as! EventDescriptionTableViewCell).loadContentView(event: self.eventObj!)
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "eventStatusTableViewCell")
            (cell as! EventStatusTableViewCell).loadContentView(event: self.eventObj!)
            break
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 0:
            guard let attachmentObj = self.eventObj?.attachments?.first, let _ = attachmentObj.url else {
                return 0
            }
            return 200
        case 5:
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
