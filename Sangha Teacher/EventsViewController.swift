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
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendarView, action: #selector(self.calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()

    var presentDatesArray:[String] = []
    
    var absentDatesArray:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        
        self.view.addGestureRecognizer(self.scopeGesture)
        
        self.presentDatesArray = ["2017-09-03",
                                  "2017-09-06",
                                  "2017-09-12",
                                  "2017-09-25"];
        
        self.absentDatesArray = ["2017-09-10",
                                 "2017-09-18",
                                 "2017-09-15",
                                 "2017-09-16"];

        self.calendarView.appearance.headerTitleFont = UIFont(name: AppFont.appFontDemiBold, size: 25)
        
        self.calendarView.appearance.weekdayFont = UIFont(name: AppFont.appFontDemiBold, size: 13)
        
        self.calendarView.appearance.titleFont = UIFont(name: AppFont.appFontMedium, size: 15)
        
        
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
                    
                    
                    print(response ?? "")
                    
                }else {
                    
                    self.showAlert(withTitle: response?["message"] as? String ?? "No resposne", message:"")
                }
            }else{
                
                self.showAlert(withTitle: Messages.networkErrorTitle, message: Messages.networkErrorMessage)
            }
            
        }
        
        
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
        
        let dateString = self.dateFormatter.string(from: date)
        
        if presentDatesArray.contains(dateString){
            
            return 2
            
        }else if absentDatesArray.contains(dateString){
            
            return 1
        }else{
            
            return 0
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {

        let dateString = self.dateFormatter.string(from: date)
        
        if presentDatesArray.contains(dateString){
            
            return [UIColor.red,UIColor.brown]
            
        }else if absentDatesArray.contains(dateString){
            
            return [UIColor.black, UIColor.green]
        }else{
            
            return [UIColor.clear]
        }
        
    }

}
