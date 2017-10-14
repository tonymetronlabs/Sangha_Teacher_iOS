//
//  RSVPViewController.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/9/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class AIHeaderViewModel : NSObject
{
    var responceEnum:AIResponceEnum = .none
    var isCollapsed:Bool = false
    
    static let shared = AIHeaderViewModel()
    
    
    func parse(aiResponce:[AIResponceEnum]) -> [AIHeaderViewModel]
    {
        var tempArray:[AIHeaderViewModel] = []
        
        for aiResponceObj in aiResponce
        {
            let obj = AIHeaderViewModel()
            
            obj.isCollapsed = true
            obj.responceEnum = aiResponceObj
            
            tempArray.append(obj)
        }
        
        return tempArray
    }
}

class RSVPViewController: UIViewController {

    @IBOutlet var rsvpTableView: UITableView!
    @IBOutlet var maxGuestsPerStudentLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var deadLineDateLabel: UILabel!
    var aiHeaderModelArray:[AIHeaderViewModel] = []
    var eventsObj:Event?
    var rsvpListModel:RSVPListModel?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableviewCell()

        aiHeaderModelArray = AIHeaderViewModel.shared.parse(aiResponce: [AIResponceEnum.accepted,AIResponceEnum.rejected,AIResponceEnum.noResponce])

        self.getRsvpListService { (success, rsvpLists) in
            
            if success
            {
                self.rsvpListModel = rsvpLists
                
                self.rsvpTableView.reloadData()
                
                self.maxGuestsPerStudentLabel.text = "Max guests/student: \(self.rsvpListModel?.ai?.maxpr ?? 0)"
                
                self.deadLineDateLabel.text = self.rsvpListModel?.ai?.deadline?.toDateFromString(dateFormat: ToDateFormat.ActionItemDateFormat.rawValue).toString(dateFormat: ToStringDateFormat.ActionItemStringFormat.rawValue)
                
                self.capacityLabel.text = "Capacity: \(self.rsvpListModel?.ai?.capacity ?? 0)"
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    fileprivate func registerTableviewCell()
    {
        self.rsvpTableView.register(ActionItemRsvpHeaderFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionItemRsvpHeaderFooterView.identifier)
        
        self.rsvpTableView.register(StudentResponceTableViewCell.nib, forCellReuseIdentifier: StudentResponceTableViewCell.identifier)
        
        self.rsvpTableView.register(StudentNameAndImageTableViewCell.nib, forCellReuseIdentifier: StudentNameAndImageTableViewCell.identifier)

        self.rsvpTableView.backgroundView = UIView()
        self.rsvpTableView.backgroundColor = .white
    }
    
}

extension RSVPViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.rsvpListModel == nil {
            return 0
        }
        
        return aiHeaderModelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
         return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
            let headerObj = aiHeaderModelArray[section]

        switch section {
        case 0:
            
            guard let studentCount = rsvpListModel?.ai?.responses?.accepts?.count else { return 0 }

            let height:CGFloat =  (studentCount > 0) ? 0.0 : 10.0

            return (headerObj.isCollapsed) ? 10 : height

        case 1:
            
                guard let studentCount = rsvpListModel?.ai?.responses?.rejects?.count else { return 0 }

                let height:CGFloat =  (studentCount > 0) ? 0.0 : 10.0

                return height

        case 2:
            
            guard let studentCount = rsvpListModel?.ai?.responses?.pending?.count else { return 0 }
            
            let height:CGFloat =  (studentCount > 0) ? 0.0 : 10.0

            return (headerObj.isCollapsed) ? 10 : height

        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.section
        {
        case 0:
            
            return StudentResponceTableViewCell.cellSize

        case 1:
            return StudentNameAndImageTableViewCell.cellSize

        case 2:
            
            return StudentNameAndImageTableViewCell.cellSize

        default :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        

        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActionItemRsvpHeaderFooterView.identifier) as? ActionItemRsvpHeaderFooterView {
            
            let headerObj = aiHeaderModelArray[section]

            headerView.delegate = self
            headerView.indexPath = IndexPath(row: 0, section: section)
            switch headerObj.responceEnum
            {
            case .accepted:
                //TODO:-
                if let intArray = rsvpListModel?.ai?.responses?.accepts?.map({ $0?.guestsCount })
                {
                    
                    var addedInt:Int = 0
                    for i in intArray
                    {
                        addedInt = addedInt + i!
                    }
                    
                        guard let studentCount = rsvpListModel?.ai?.responses?.accepts?.count else { return UIView() }
                        
                        headerView.updateUI(responceCount: "\(studentCount) Student (\(addedInt) Parents)", aiHeaderViewObj: headerObj)
                }
                
            case .rejected:
                
                guard let studentCount = rsvpListModel?.ai?.responses?.rejects?.count else { return UIView() }
                
                
                headerView.updateUI(responceCount: "\(studentCount) Student", aiHeaderViewObj: headerObj)
                
            case .noResponce:
                
                guard let studentCount = rsvpListModel?.ai?.responses?.pending?.count else { return  UIView()}

                headerView.updateUI(responceCount: "\(studentCount) Student", aiHeaderViewObj: headerObj)

            default:
                return UIView()
            }
            
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let headerObj = aiHeaderModelArray[section]

        switch section
        {
        case 0:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                guard let count = self.rsvpListModel?.ai?.responses?.accepts?.count else { return 0}
                
                return count
            }
        case 1:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                guard let count = self.rsvpListModel?.ai?.responses?.rejects?.count else { return 0}
                
                return count
            }
        case 2:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                guard let count = self.rsvpListModel?.ai?.responses?.pending?.count else { return 0 }

                return count
            }
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
     
        switch indexPath.section {
        case 0:
            
            let studentResponceCell = tableView.dequeueReusableCell(withIdentifier:StudentResponceTableViewCell.identifier , for: indexPath) as! StudentResponceTableViewCell
            
                guard let acceptObj = self.rsvpListModel?.ai?.responses?.accepts![indexPath.row] else { return UITableViewCell() }
            
                studentResponceCell.updateUI(acceptsObj: acceptObj)
            
            return studentResponceCell
            
        case 1:
            
            let studentNameCell = tableView.dequeueReusableCell(withIdentifier: StudentNameAndImageTableViewCell.identifier, for: indexPath) as! StudentNameAndImageTableViewCell
            
            guard let rejectObj = self.rsvpListModel?.ai?.responses?.rejects![indexPath.row] else { return UITableViewCell() }

            studentNameCell.updateUI(student: rejectObj.studentName!)
            
            return studentNameCell
            
        case 2:
            
            let studentNameCell = tableView.dequeueReusableCell(withIdentifier: StudentNameAndImageTableViewCell.identifier, for: indexPath) as! StudentNameAndImageTableViewCell
            
            guard let pendingObj = self.rsvpListModel?.ai?.responses?.pending![indexPath.row] else { return UITableViewCell() }
            
            studentNameCell.updateUI(student: pendingObj.studentName!)
            
            return studentNameCell
            
        default:
          return UITableViewCell()
        }
        
        
    }
    
}

extension RSVPViewController : ActionItemRsvpHeaderFooterViewDelegate
{
    func didTapHeaderView(indexpath: IndexPath)
    {
        let headerObj = self.aiHeaderModelArray[indexpath.section]
        
        switch indexpath.section {
        case 0:
            guard let count = self.rsvpListModel?.ai?.responses?.accepts?.count,count > 0 else {
                
                return
                
            }

            headerObj.isCollapsed = !headerObj.isCollapsed

        case 1:
            guard let count = self.rsvpListModel?.ai?.responses?.rejects?.count,count > 0 else {
                
                return
                
            }
            
            headerObj.isCollapsed = !headerObj.isCollapsed

        case 2:
            guard let count = self.rsvpListModel?.ai?.responses?.pending?.count,count > 0 else {
                return
            }
            
            headerObj.isCollapsed = !headerObj.isCollapsed

            default:
            break
            
        }
        
        
        self.rsvpTableView.reloadData()
    }
}

extension RSVPViewController{
    
    func getRsvpListService(completionHandler:@escaping (_ isSuccess:Bool,_ rsvpLists:RSVPListModel?) -> Void)
    {
        
        
        let actionItem = eventsObj?.ais?.filter{ $0.aiType == AiType.rsvp }.first
        
        guard let actionId = actionItem?.id else { return }
        
        guard let eventId = eventsObj?.id else { return }
        
        let rsvpListApi = API.GetRsvpLists.init(eventId: eventId, actionItemId: actionId)
        
        APIHandler.sharedInstance.initWithAPIUrl(rsvpListApi.URL, method: rsvpListApi.APIMethod, params: rsvpListApi.param, currentView: self) { (success, responseDict, responseData) in
            
            if success
            {
                    do {
                        
                        guard let data = responseData else
                        {
                            completionHandler(false,nil)
                        
                            return
                        }
                        
                        let rsvpListModel = try JSONDecoder().decode(RSVPListModel.self, from: data)
                        
                        switch rsvpListModel.status
                        {
                        case 200?:
                            print(rsvpListModel.ai?.responses?.accepts?.count ?? "Result nil")

                            completionHandler(true,rsvpListModel)
                            
                            break
                            
                        default:
                            completionHandler(false,nil)
                            break
                        }
                        
                    }
                    catch
                    {
                        completionHandler(false,nil)
                        print(error)
                    }
                    
                    
                
            }
            else{
                completionHandler(false,nil)

                self.showAlert(withTitle: Messages.networkErrorTitle, message: Messages.networkErrorMessage)
            }
        
    }
    
    }
}







