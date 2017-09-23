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
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //2017-09-12T00:00:00.000Z
        return formatter
    }()
    
    
    fileprivate lazy var displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy" //2017-09-12T00:00:00.000Z
        return formatter
    }()
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()
    
    var eventModelArray: [Events] = []
    
    var eventsDateArray: [Date] = []
        
    var dateAndEventDictionary = [Date: [DateAndEvent]]()
    
    var greaterThanEqualToday: [Date] = []
    
    var isSpecificDate:Bool = false
    var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        self.view.addGestureRecognizer(self.scopeGesture)

        self.calendarView.appearance.headerTitleFont = UIFont(name: AppFont.appFontDemiBold, size: 25)
        
        self.calendarView.appearance.weekdayFont = UIFont(name: AppFont.appFontDemiBold, size: 13)
        
        self.calendarView.appearance.titleFont = UIFont(name: AppFont.appFontMedium, size: 12)
        
        
        self.eventsListTableView.register(EventTableViewCell.nib, forCellReuseIdentifier: EventTableViewCell.identifier)
        
        
        self.fetchEvent()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - API Call
    
    private func fetchEvent(){
                
        let nowApi =  API.NowForOrg.init(withDate: "2017-09-21", eventsOnly: "1", rt: "month", oamr: "1")
        
        print(nowApi.URL)
        
        APIHandler.sharedInstance.initWithAPIUrl(nowApi.URL, method: nowApi.APIMethod, params: nil, currentView: self) { (success, response) in
            
            if success {
                
                if response?["status"] as! Int == 200{
                    
                    self.eventModelArray = Events.modelsFromDictionaryArray(array: response?["events"] as! [Dictionary<String, Any>])
                    
                    var dateAndEvent:[DateAndEvent] = []
                    
                    for obj in self.eventModelArray{
                        
                        for scheduleDate in (obj.computedSchedule?.calendar)!{
                            
                            self.eventsDateArray.append(self.dateFormatter.date(from: scheduleDate.date!)!)
                            
                            let dateEventObject = DateAndEvent(with: self.dateFormatter.date(from: scheduleDate.date!)!, events: obj)!
                            
                            dateAndEvent.append(dateEventObject)
                            
                        }
                    }
                    
                    
                    for date in Set(self.eventsDateArray){
                        
                        let array = dateAndEvent.filter({ (event) -> Bool in
                            
                            return date == event.date
                            
                        })
                        
                        self.dateAndEventDictionary[date] = array
                        
                    }
                    
                    self.toBeDisplay()
                    
                    self.calendarView.reloadData()
                    
                }else {
                    
                    self.showAlert(withTitle: response?["message"] as? String ?? "No resposne", message:"")
                }
            }else{
                
                self.showAlert(withTitle: Messages.networkErrorTitle, message: Messages.networkErrorMessage)
            }
            
        }
        
        
    }
    
    
    private func toBeDisplay(){
    
        let sortedDateAndEventDictKeyArray = Array(self.dateAndEventDictionary.keys).sorted()
    
        self.greaterThanEqualToday = sortedDateAndEventDictKeyArray.filter { (date) -> Bool in
            
            return date > Date()
            
        }
        
        self.eventsListTableView.reloadData()
        
    }

}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (isSpecificDate) ? 1 : self.greaterThanEqualToday.count
        
        //return self.greaterThanEqualToday.count
        
        //return self.dateAndEventDictionary.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
//        let key = Array(self.dateAndEventDictionary.keys).sorted()[section]
//        let array = self.dateAndEventDictionary[key]
//        let value = array?.count
//        
//        return value!
        
        if isSpecificDate{
            
            return ((self.dateAndEventDictionary[selectedDate])?.count)!
            
        }else{
            
            let key = self.greaterThanEqualToday[section]
            
            return ((self.dateAndEventDictionary[key])?.count)!
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
//        let date = Array(self.dateAndEventDictionary.keys).sorted()[section]
//        
//        return self.displayDateFormatter.string(from: date)
        
        
        if isSpecificDate {

            return self.displayDateFormatter.string(from: selectedDate)
            
        }else{
            
            let date = self.greaterThanEqualToday[section]
            
            return self.displayDateFormatter.string(from: date)
            
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return EventTableViewCell.cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        
        let dateEvent: DateAndEvent!
        
        if isSpecificDate{
            
            dateEvent = self.dateAndEventDictionary[selectedDate]?[indexPath.row]

        }else{
            
            let keyDate = self.greaterThanEqualToday[indexPath.section]
            
            dateEvent = self.dateAndEventDictionary[keyDate]?[indexPath.row]
            
//            let event = dateEvent?.event
//            
//            cell.updateUI(with: event!)
            
        }
        
        let event = dateEvent?.event
        
        cell.updateUI(with: event!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
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
                        
                        //For Demo
                        if dateEvent.event?.docSubType == "ptm"{
                            
                            colorArray.append(UIColor.init(hex: 0xF2CF38))
                            
                        }else if dateEvent.event?.docSubType == "fieldtrip" {
                            
                            colorArray.append(UIColor.init(hex: 0x22B9F0))
                            
                        }else if dateEvent.event?.docSubType == "reminder" {
                            
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
                        if dateEvent.event?.docSubType == "ptm"{
                            
                            colorArray.append(UIColor.init(hex: 0xF2CF38))
                            
                        }else if dateEvent.event?.docSubType == "fieldtrip" {
                            
                            colorArray.append(UIColor.init(hex: 0x22B9F0))
                            
                        }else if dateEvent.event?.docSubType == "reminder" {
                            
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
