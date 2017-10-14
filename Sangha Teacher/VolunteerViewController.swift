//
//  VolunteerViewController.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/9/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class VolunteerViewController: UIViewController {

    @IBOutlet var volunteerTableView: UITableView!
    var aiHeaderModelArray:[AIHeaderViewModel] = []
    var eventsObj:Event?
    var volunteerListModel:VolunteerListModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerTableviewCell()
        
        self.getVolunteerListService { (success, volunteerLists) in
            
            if success
            {
                self.volunteerListModel = volunteerLists
                
                self.volunteerTableView.reloadData()
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
        self.volunteerTableView.register(ActionItemVolunteerHeaderFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionItemVolunteerHeaderFooterView.identifier)
        
        self.volunteerTableView.register(StudentResponceTableViewCell.nib, forCellReuseIdentifier: StudentResponceTableViewCell.identifier)
        
        self.volunteerTableView.backgroundView = UIView()
        self.volunteerTableView.backgroundColor = .white
    }

}


extension VolunteerViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        guard let count = self.volunteerListModel?.ai?.tasks?.count else { return 0}
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        guard let task = volunteerListModel?.ai?.tasks?[section].responses?.count else { return 0 }
        
        let height:CGFloat =  (task > 0) ? 0.0 : 10.0
        
        let isCollapsed = volunteerListModel?.ai?.tasks?[section].isCollapsed ?? false
        
        return isCollapsed ? 10 : height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return StudentResponceTableViewCell.cellSize
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActionItemVolunteerHeaderFooterView.identifier) as? ActionItemVolunteerHeaderFooterView {
            
            guard let taskObj = self.volunteerListModel?.ai?.tasks![section] else { return UIView() }
            
            headerView.delegate = self
            
            headerView.indexPath = IndexPath(row: 0, section: section)
            
            let isCollapsed = taskObj.isCollapsed ?? false

            headerView.updateUI(detail: taskObj.desc! , title: taskObj.title!, isCollapsed: isCollapsed)
            
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let taskObj = volunteerListModel?.ai?.tasks?[section] else { return 0 }
        
        let isCollapsed = taskObj.isCollapsed ?? false

        if isCollapsed
        {
            return 0
        }
        
        guard let count = taskObj.responses?.count else { return 0 }
     
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let studentCell = tableView.dequeueReusableCell(withIdentifier: StudentResponceTableViewCell.identifier, for: indexPath) as! StudentResponceTableViewCell
        
        guard let taskObj = volunteerListModel?.ai?.tasks?[indexPath.section] else { return UITableViewCell() }

        studentCell.updateUI(responses: taskObj.responses![indexPath.row])
        
       return studentCell
        
    }
    
}

extension VolunteerViewController : ActionItemVolunteerHeaderFooterDelegate
{
    
    func didTapVolunteerHeaderView(indexpath: IndexPath)
    {
        guard let taskObj = self.volunteerListModel?.ai?.tasks![indexpath.section] else { return }
        
        let isCollapsed = taskObj.isCollapsed ?? false
        
        taskObj.isCollapsed = !isCollapsed
        
        self.volunteerTableView.reloadData()
    }
}

extension VolunteerViewController{
    
    func getVolunteerListService(completionHandler:@escaping (_ isSuccess:Bool,_ volunteerLists:VolunteerListModel?) -> Void)
    {
        let actionItem = eventsObj?.ais?.filter{ $0.aiType == AiType.volunteer }.first
        
        guard let actionId = actionItem?.id else { return }
        
        guard let eventId = eventsObj?.id else { return }
        
        let volunteerListsApi = API.GetVolunteerLists.init(eventId: eventId, actionItemId: actionId)
        
        APIHandler.sharedInstance.initWithAPIUrl(volunteerListsApi.URL, method: volunteerListsApi.APIMethod, params: volunteerListsApi.param, currentView: self) { (success, responseDict, responseData) in
            
            if success
            {
                do {
                    
                    guard let data = responseData else
                    {
                        completionHandler(false,nil)
                        
                        return
                    }
                    
                    let volunteerListModel = try JSONDecoder().decode(VolunteerListModel.self, from: data)
                    
                    switch volunteerListModel.status
                    {
                    case 200?:
                        print(volunteerListModel.ai?.tasks?.count ?? "Result nil")
                        
                        completionHandler(true,volunteerListModel)
                        
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


