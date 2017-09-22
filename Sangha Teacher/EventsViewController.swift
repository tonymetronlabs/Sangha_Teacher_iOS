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
    
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()
    
    var eventModelArray: [Events] = []
    
    var eventsDateArray: [Date] = []
    
    var dateAndEvent:[DateAndEvent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        self.view.addGestureRecognizer(self.scopeGesture)

        self.calendarView.appearance.headerTitleFont = UIFont(name: AppFont.appFontDemiBold, size: 25)
        
        self.calendarView.appearance.weekdayFont = UIFont(name: AppFont.appFontDemiBold, size: 13)
        
        self.calendarView.appearance.titleFont = UIFont(name: AppFont.appFontMedium, size: 15)
        
        
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
        
        print(Date())
        
        let nowApi =  API.NowForOrg.init(withDate: "2017-09-21", eventsOnly: "1", rt: "month", oamr: "1")
        
        print(nowApi.URL)
        
        APIHandler.sharedInstance.initWithAPIUrl(nowApi.URL, method: nowApi.APIMethod, params: nil, currentView: self) { (success, response) in
            
            if success {
                
                if response?["status"] as! Int == 200{
                    
                    print(response ?? "")
                    
                    self.eventModelArray = Events.modelsFromDictionaryArray(array: response?["events"] as! [Dictionary<String, Any>])
                    

                    for obj in self.eventModelArray{
                        
                        for scheduleDate in (obj.computedSchedule?.calendar)!{
                            
                            print(scheduleDate.date ?? "No date")
                            
                            self.eventsDateArray.append(self.dateFormatter.date(from: scheduleDate.date!)!)
                            
                            self.dateAndEvent.append(DateAndEvent(with: self.dateFormatter.date(from: scheduleDate.date!)!, event: obj)!)
                            
                        }
                    }
                    
                    print(self.dateAndEvent)

                    
                    print(Set(self.eventsDateArray))
                    print(Set(self.eventsDateArray).sorted())
                    
                    let array = Set(self.eventsDateArray).sorted()
                    
                    print(array.filter({ (date) -> Bool in
                        
                        return date >= Date()
                        
                    }))
                    
                    self.eventsListTableView.reloadData()
                    
                    self.calendarView.reloadData()
                    
                }else {
                    
                    self.showAlert(withTitle: response?["message"] as? String ?? "No resposne", message:"")
                }
            }else{
                
                self.showAlert(withTitle: Messages.networkErrorTitle, message: Messages.networkErrorMessage)
            }
            
        }
        
        
    }

}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventModelArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return EventTableViewCell.cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        
        let event = self.eventModelArray[indexPath.row]
        
        cell.updateUI(with: event)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EventsViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.eventsListTableView.contentOffset.y <= -self.eventsListTableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
}

extension EventsViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        self.calendarViewHeightConstraint.constant = bounds.height
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        
        if self.eventsDateArray.contains(date){
            
            return 1
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        return [UIColor(hex: AppColor.appEventColor)]
        
    }

}
