//
//  PaymentViewController.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/9/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    
    
    @IBOutlet var paymentTableView: UITableView!
    @IBOutlet var maxGuestsPerStudentLabel: UILabel!
    @IBOutlet var paymentFeeAndTitleDateLabel: UILabel!
    var aiHeaderModelArray:[AIHeaderViewModel] = []
    var eventsObj:Event?
    var paymentListModel:PaymentListModel?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        registerTableviewCell()
        
        aiHeaderModelArray = AIHeaderViewModel.shared.parse(aiResponce: [AIResponceEnum.accepted,AIResponceEnum.rejected,AIResponceEnum.noResponce])
        
        self.getPaymentListService { (success, paymentLists) in
            
            if success
            {
                self.paymentListModel = paymentLists
                
                self.paymentTableView.reloadData()
                
                self.maxGuestsPerStudentLabel.text = "Max guests/student: \(self.paymentListModel?.ai?.maxpr ?? 0)"
                
                self.deadLineDateLabel.text = self.paymentListModel?.ai?.deadline?.toDateFromString(dateFormat: ToDateFormat.ActionItemDateFormat.rawValue).toString(dateFormat: ToStringDateFormat.ActionItemStringFormat.rawValue)
                
                self.capacityLabel.text = "Capacity: \(self.paymentListModel?.ai?.capacity ?? 0)"
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
        self.paymentTableView.register(ActionItemRsvpHeaderFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionItemRsvpHeaderFooterView.identifier)
        
        self.paymentTableView.register(StudentResponceTableViewCell.nib, forCellReuseIdentifier: StudentResponceTableViewCell.identifier)
        
        self.paymentTableView.register(StudentNameAndImageTableViewCell.nib, forCellReuseIdentifier: StudentNameAndImageTableViewCell.identifier)
        
        self.paymentTableView.backgroundView = UIView()
        self.paymentTableView.backgroundColor = .white
    }

}


extension PaymentViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.paymentListModel == nil {
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
            
            guard let studentCount = paymentListModel?.ai?.responses?.accepts?.amount else { return 0 }
            
            let height:CGFloat =  (studentCount > 0) ? 0.0 : 10.0
            
            return (headerObj.isCollapsed) ? 10 : height
            
        case 1:
            
            guard let studentCount = paymentListModel?.ai?.responses?.pending else { return 0 }
            
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
                if let intArray = paymentListModel?.ai?.responses?.accepts?.map({ $0?.guestsCount })
                {
                    
                    var addedInt:Int = 0
                    for i in intArray
                    {
                        addedInt = addedInt + i!
                    }
                    
                    guard let studentCount = paymentListModel?.ai?.responses?.accepts?.count else { return UIView() }
                    
                    headerView.updateUI(responceCount: "\(studentCount) Student (\(addedInt) Parents)", aiHeaderViewObj: headerObj)
                }
         
            case .noResponce:
                
                guard let studentCount = paymentListModel?.ai?.responses?.pending?.count else { return  UIView()}
                
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
                guard let count = self.paymentListModel?.ai?.responses?.accepts?.count else { return 0}
                
                return count
            }
        case 1:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                guard let count = self.paymentListModel?.ai?.responses?.rejects?.count else { return 0}
                
                return count
            }
        case 1:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                guard let count = self.paymentListModel?.ai?.responses?.pending?.count else { return 0 }
                
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
            
            guard let acceptObj = self.paymentListModel?.ai?.responses?.accepts![indexPath.row] else { return UITableViewCell() }
            
            studentResponceCell.updateUI(acceptsObj: acceptObj)
            
            return studentResponceCell
            
        case 1:
            
            let studentNameCell = tableView.dequeueReusableCell(withIdentifier: StudentNameAndImageTableViewCell.identifier, for: indexPath) as! StudentNameAndImageTableViewCell
            
            guard let pendingObj = self.paymentListModel?.ai?.responses?.pending![indexPath.row] else { return UITableViewCell() }
            
            studentNameCell.updateUI(student: pendingObj.studentName!)
            
            return studentNameCell
            
        default:
            return UITableViewCell()
        }
        
        
    }
    
}

extension PaymentViewController : ActionItemRsvpHeaderFooterViewDelegate
{
    func didTapHeaderView(indexpath: IndexPath)
    {
        let headerObj = self.aiHeaderModelArray[indexpath.section]
        
        switch indexpath.section {
        case 0:
            guard let count = self.paymentListModel?.ai?.responses?.accepts?.count,count > 0 else {
                
                return
                
            }
            
            headerObj.isCollapsed = !headerObj.isCollapsed
            
        
        case 1:
            guard let count = self.paymentListModel?.ai?.responses?.pending?.count,count > 0 else {
                return
            }
            
            headerObj.isCollapsed = !headerObj.isCollapsed
            
        default:
            break
            
        }
        
        
        self.paymentTableView.reloadData()
    }
}

extension PaymentViewController{
    
    func getPaymentListService(completionHandler:@escaping (_ isSuccess:Bool,_ paymentList:PaymentListModel?) -> Void)
    {
        
        
        let actionItem = eventsObj?.ais?.filter{ $0.aiType == AiType.payment }.first
        
        guard let actionId = actionItem?._id else { return }
        
        guard let eventId = eventsObj?._id else { return }
        
        let paymentListApi = API.GetRsvpLists.init(eventId: eventId, actionItemId: actionId)
        
        APIHandler.sharedInstance.initWithAPIUrl(paymentListApi.URL, method: paymentListApi.APIMethod, params: paymentListApi.param, currentView: self) { (success, responseDict, responseData) in
            
            if success
            {
                do {
                    
                    guard let data = responseData else
                    {
                        completionHandler(false,nil)
                        
                        return
                    }
                    
                    let paymentListModel = try JSONDecoder().decode(PaymentListModel.self, from: data)
                    
                    switch paymentListModel.status
                    {
                    case 200?:
                        print(paymentListModel.ai?.responses?.accepts?.count ?? "Result nil")
                        
                        completionHandler(true,paymentListModel)
                        
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






