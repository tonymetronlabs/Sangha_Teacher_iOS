//
//  FormViewController.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/9/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    
    @IBOutlet var formTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var deadLineDateLabel: UILabel!
    var aiHeaderModelArray:[AIHeaderViewModel] = []
    var eventsObj:Event?
    var formListModel:FormListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableviewCell()
        
        aiHeaderModelArray = AIHeaderViewModel.shared.parse(aiResponce: [AIResponceEnum.accepted,AIResponceEnum.noResponce])
        
        self.getFormListService { (success, formLists) in
            
            if success
            {
                self.formListModel = formLists
                
                self.formTableView.reloadData()
                
                self.deadLineDateLabel.text = "Deadline: " + (self.formListModel?.ai?.deadline?.toDateFromString(dateFormat: ToDateFormat.ActionItemDateFormat.rawValue).toString(dateFormat: ToStringDateFormat.ActionItemStringFormat.rawValue))!
                

                self.titleLabel.text = self.formListModel?.ai?.title
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func registerTableviewCell()
    {
        self.formTableView.register(ActionItemRsvpHeaderFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionItemRsvpHeaderFooterView.identifier)
        
        self.formTableView.register(StudentResponceTableViewCell.nib, forCellReuseIdentifier: StudentResponceTableViewCell.identifier)
        
        self.formTableView.register(StudentNameAndImageTableViewCell.nib, forCellReuseIdentifier: StudentNameAndImageTableViewCell.identifier)
        
        self.formTableView.backgroundView = UIView()
        self.formTableView.backgroundColor = .white
    }
    
}


extension FormViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
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
            
            guard let studentCount = formListModel?.ai?.responses?.accepts?.count else { return 0 }
            
            let height:CGFloat =  (studentCount > 0) ? 0.0 : 10.0
            
            return (headerObj.isCollapsed) ? 10 : height
            
        case 1:
            
            guard let studentCount = formListModel?.ai?.responses?.pending?.count else { return 0 }
            
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
                
                guard let studentCount = formListModel?.ai?.responses?.accepts?.count else { return UIView() }
                
                headerView.updateUI(responceCount: "\(studentCount) Student", aiHeaderViewObj: headerObj)
                
                
            case .rejected:
                
                guard let studentCount = formListModel?.ai?.responses?.rejects?.count else { return UIView() }
                
                
                headerView.updateUI(responceCount: "\(studentCount) Student", aiHeaderViewObj: headerObj)
                
            case .noResponce:
                
                guard let studentCount = formListModel?.ai?.responses?.pending?.count else { return  UIView()}
                
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
                guard let count = self.formListModel?.ai?.responses?.accepts?.count else { return 0}
                
                return count
            }
        case 1:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                guard let count = self.formListModel?.ai?.responses?.pending?.count else { return 0 }
                
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
            
            guard let acceptObj = self.formListModel?.ai?.responses?.accepts![indexPath.row] else { return UITableViewCell() }
            
            studentResponceCell.updateUI(acceptsObj: acceptObj)
            
            return studentResponceCell
            
            
        case 1:
            
            let studentNameCell = tableView.dequeueReusableCell(withIdentifier: StudentNameAndImageTableViewCell.identifier, for: indexPath) as! StudentNameAndImageTableViewCell
            
            guard let pendingObj = self.formListModel?.ai?.responses?.pending![indexPath.row] else { return UITableViewCell() }
            
            studentNameCell.updateUI(student: pendingObj.studentName!)
            
            return studentNameCell
            
        default:
            return UITableViewCell()
        }
        
        
    }
    
}

extension FormViewController : ActionItemRsvpHeaderFooterViewDelegate
{
    func didTapHeaderView(indexpath: IndexPath)
    {
        let headerObj = self.aiHeaderModelArray[indexpath.section]
        
        switch indexpath.section {
        case 0:
            guard let count = self.formListModel?.ai?.responses?.accepts?.count,count > 0 else {
                
                return
                
            }
            
            headerObj.isCollapsed = !headerObj.isCollapsed
            
        case 1:
            guard let count = self.formListModel?.ai?.responses?.pending?.count,count > 0 else {
                return
            }
            
            headerObj.isCollapsed = !headerObj.isCollapsed
            
        default:
            break
            
        }
        
        
        self.formTableView.reloadData()
    }
}

extension FormViewController{
    
    func getFormListService(completionHandler:@escaping (_ isSuccess:Bool,_ formLists:FormListModel?) -> Void)
    {
        
        
        let actionItem = eventsObj?.ais?.filter{ $0.aiType == AiType.form }.first
        
        guard let actionId = actionItem?.id else { return }
        
        guard let eventId = eventsObj?.id else { return }
        
        let formListApi = API.GetFormLists.init(eventId: eventId, actionItemId: actionId)
        
        APIHandler.sharedInstance.initWithAPIUrl(formListApi.URL, method: formListApi.APIMethod, params: formListApi.param, currentView: self) { (success, responseDict, responseData) in
            
            if success
            {
                do {
                    
                    guard let data = responseData else
                    {
                        completionHandler(false,nil)
                        
                        return
                    }
                    
                    let formListModel = try JSONDecoder().decode(FormListModel.self, from: data)
                    
                    switch formListModel.status
                    {
                    case 200?:
                        print(formListModel.ai?.responses?.accepts?.count ?? "Result nil")
                        
                        completionHandler(true,formListModel)
                        
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
