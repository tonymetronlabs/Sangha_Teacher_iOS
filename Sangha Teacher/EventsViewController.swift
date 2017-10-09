//
//  EventsViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/20/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit
import FSCalendar

class EventsViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eventsListTableView: UITableView!

    @IBOutlet weak var announcementBarButton: UIBarButtonItem!

    @IBOutlet weak var chatBarButton: UIBarButtonItem!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //2017-09-12T00:00:00.000Z
        return formatter
    }()
    
    fileprivate lazy var displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM dd yyyy"
        return formatter
    }()
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()

    var eventListModel : EventList = EventList()
    var eventModelArray: [Event] = []
    var eventsDateArray: [Date] = []
    var dateAndEventDictionary = [Date: [DateAndEvent]]()
    var greaterThanEqualToday: [Date] = []
    var isSpecificDate:Bool = false
    var selectedDate: Date! = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.scopeGesture)

        self.calendarView.scope = .week

        self.calendarView.appearance.headerTitleFont = UIFont(name: AppFont.appFontSemiBold, size: 25)
        
        self.calendarView.appearance.weekdayFont = UIFont(name: AppFont.appFontSemiBold, size: 13)
        
        self.calendarView.appearance.titleFont = UIFont(name: AppFont.appFontBold, size: 12)
        
        
        self.eventsListTableView.register(EventTableViewCell.nib, forCellReuseIdentifier: EventTableViewCell.identifier)
        
        self.eventsListTableView.register(EventTableHeaderView.nib, forHeaderFooterViewReuseIdentifier: EventTableHeaderView.identifier)
        
        self.fetchEvent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func menuButtonAction(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    // MARK: - API Call
    private func fetchEvent(){
                
        let nowApi =  API.NowForOrg.init(withDate: "2017-10-03", eventsOnly: "1", rt: "month", oamr: "1")

        APIHandler.sharedInstance.initWithAPIUrl(nowApi.URL, method: nowApi.APIMethod, params: nil, currentView: self) { (success, responseDict, responseData) in
            
            if success {

                let status = responseDict?["status"] as! Int

                switch status {

                    case 200:
                        let decoder = JSONDecoder()

                        do {
                            self.eventListModel = try decoder.decode(EventList.self, from: responseData!)

                            self.eventModelArray = self.eventListModel.events

                            var dateAndEvent:[DateAndEvent] = []

                            for obj in self.eventModelArray {

//                                _ = obj.ais?.filter { (aisObj) -> Bool in
//                                    print(aisObj.aiType!)
//                                    return true
//                                }

                                for scheduleDate in (obj.computedSchedule?.calendar)!{

                                    self.eventsDateArray.append(self.dateFormatter.date(from: scheduleDate.date!)!)

                                    let dateEventObject = DateAndEvent(with: self.dateFormatter.date(from: scheduleDate.date!)!, events: obj)!

                                    dateAndEvent.append(dateEventObject)
                                }
                            }


                            for date in Set(self.eventsDateArray){

                                let array = dateAndEvent.filter({ (event) -> Bool in

                                    return date.compare(event.date) == .orderedSame
                                })

                                self.dateAndEventDictionary[date] = array

                                print(self.dateAndEventDictionary)
                            }

                            self.toBeDisplay()
                            self.updateBarButtons()
                            self.calendarView.reloadData()
                        }
                        catch let error {
                            print(error.localizedDescription)
                    }
                     break
                case 403:
                    self.showAlert(withTitle: responseDict?["message"] as? String ?? "No response", message:"")
                    Utilities.sharedInstance.logoutAction(viewController: self)
                    break
                default:
                    self.showAlert(withTitle: responseDict?["message"] as? String ?? "No response", message:"")
                    break
                }
            }
            else{
                self.showAlert(withTitle: Messages.networkErrorTitle, message: Messages.networkErrorMessage)
            }
        }
    }

    private func updateBarButtons() {
        self.chatBarButton.badgeValue = "\(self.eventListModel.unreadMsgCounts.chatsCount ?? 0)"
        self.chatBarButton.badgeFont = UIFont(name: AppFont.appFontCondSemiBold, size: 15)
        self.chatBarButton.badgeTextColor = UIColor.white
        self.chatBarButton.badgeBGColor = UIColor.red

        self.announcementBarButton.badgeValue = "\(self.eventListModel.unreadMsgCounts.messagesCount ?? 0)"
        self.announcementBarButton.badgeFont = UIFont(name: AppFont.appFontCondSemiBold, size: 15)
        self.announcementBarButton.badgeTextColor = UIColor.white
        self.announcementBarButton.badgeBGColor = UIColor.red
    }

    private func toBeDisplay(){
    
        let sortedDateAndEventDictKeyArray = Array(self.dateAndEventDictionary.keys).sorted()
    
        self.greaterThanEqualToday = sortedDateAndEventDictKeyArray.filter { (date) -> Bool in

            return date >= Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        }

        self.eventsListTableView.reloadData()
    }

}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (isSpecificDate) ? 1 : self.greaterThanEqualToday.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return EventTableHeaderView.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderView.identifier) as! EventTableHeaderView
        
        if isSpecificDate {
            
            headerView.dateLabel.text = self.displayDateFormatter.string(from: selectedDate)
            
        }else{
            
            let date = self.greaterThanEqualToday[section]
            
            if date == (Calendar.current.date(byAdding: .day, value: -1, to: Date())!) {
                
                headerView.dateLabel.text = "Today" + (self.displayDateFormatter.string(from: date))
            
            }else{
                
                headerView.dateLabel.text = self.displayDateFormatter.string(from: date)
                
            }
            
        }
        
        return headerView
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSpecificDate{
            
            guard let date = self.dateAndEventDictionary[selectedDate] else {
                return 0
            }
            
            return date.count
            
        }else{
            
            let key = self.greaterThanEqualToday[section]
            
            return ((self.dateAndEventDictionary[key])?.count)!
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let dateEvent: DateAndEvent!

        if isSpecificDate{
            dateEvent = self.dateAndEventDictionary[selectedDate]?[indexPath.row]
        }else{
            let keyDate = self.greaterThanEqualToday[indexPath.section]
            dateEvent = self.dateAndEventDictionary[keyDate]?[indexPath.row]
        }

        let event = dateEvent?.event
        return EventTableViewCell.getCellHeight(with: event!, selectedDate: self.selectedDate)
//        return EventTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        
        let dateEvent: DateAndEvent!
        
        if isSpecificDate{
            
            dateEvent = self.dateAndEventDictionary[selectedDate]?[indexPath.row]

        }else{
            
            let keyDate = self.greaterThanEqualToday[indexPath.section]
            
            dateEvent = self.dateAndEventDictionary[keyDate]?[indexPath.row]
        }
        
        let event = dateEvent?.event
        
        cell.updateUI(with: event!,selectedDate: self.selectedDate)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        let dateEvent: DateAndEvent!

        if isSpecificDate{

            dateEvent = self.dateAndEventDictionary[selectedDate]?[indexPath.row]

        }else{

            let keyDate = self.greaterThanEqualToday[indexPath.section]

            dateEvent = self.dateAndEventDictionary[keyDate]?[indexPath.row]
        }

        let event = dateEvent?.event

        let eventDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SBEventDetail") as! EventDetailViewController
        eventDetailVC.eventObj = event
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
    }
}

extension EventsViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity = self.scopeGesture.velocity(in: self.view)
        switch self.calendarView.scope {
        case .month:
            return velocity.y < 0
        case .week:
            return velocity.y > 0
        }
    }
}

extension EventsViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        self.calendarViewHeightConstraint.constant = bounds.height
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if self.eventsDateArray.contains(date){
            
            for (key, value) in self.dateAndEventDictionary{
                
                if key == date {
                    
                    return value.count
                }
                
            }
            
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        if self.eventsDateArray.contains(date){
            
            for (key, value) in self.dateAndEventDictionary{
                
                if key == date {
                    
                    var colorArray:[UIColor] = []
                    
                    for dateEvent in value{
                        
                        /*let type = EventType(rawValue: (dateEvent.event?.docSubType)!)!
                        switch type {
                        case .ptm:
                            
                            break
                            
                        case .fieldTrip:
                            
                            break
                            
                        case .reminder:
                            
                            break
                            
                        }*/
                        
                        //For Demo
                        if dateEvent.event.docSubType == "ptm"{
                            
                            colorArray.append(UIColor.init(hex: 0xF2CF38))
                            
                        }else if dateEvent.event.docSubType == "fieldtrip" {
                            
                            colorArray.append(UIColor.init(hex: 0x22B9F0))
                            
                        }else if dateEvent.event.docSubType == "reminder" {
                            
                            colorArray.append(UIColor.init(hex: 0x53F9AE))
                        }else{
                            
                            colorArray.append(UIColor.gray)
                        }
                        
                    }
                    
                    return colorArray
                }
                
            }
            
        }
        
        return [UIColor.green]
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        
        if self.eventsDateArray.contains(date){
            
            for (key, value) in self.dateAndEventDictionary{
                
                if key == date {
                    
                    var colorArray:[UIColor] = []
                    
                    for dateEvent in value{
                        
                        //For Demo
                        if dateEvent.event.docSubType == "ptm"{
                            
                            colorArray.append(UIColor.init(hex: 0xF2CF38))
                            
                        }else if dateEvent.event.docSubType == "fieldtrip" {
                            
                            colorArray.append(UIColor.init(hex: 0x22B9F0))
                            
                        }else if dateEvent.event.docSubType == "reminder" {
                            
                            colorArray.append(UIColor.init(hex: 0x53F9AE))
                        }else{
                            
                            colorArray.append(UIColor.gray)
                        }
                        
                    }
                    
                    return colorArray
                }
                
            }
            
        }
        
        return [UIColor.green]
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        self.selectedDate = date
        
        self.isSpecificDate = true
        
        self.eventsListTableView.reloadData()
        
    }
}
