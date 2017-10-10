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
    
    func parse() -> [AIHeaderViewModel]
    {
        var tempArray:[AIHeaderViewModel] = []
        
        for i in 1..<4 {
            
            let obj = AIHeaderViewModel()
            
            obj.isCollapsed = false
            obj.responceEnum = AIResponceEnum(rawValue: i)!
            
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
    var aiHeaderViewArray:[AIHeaderViewModel] = AIHeaderViewModel.shared.parse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rsvpTableView.register(ActionItemRsvpHeaderFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionItemRsvpHeaderFooterView.identifier)

        self.rsvpTableView.backgroundView = UIView()
        self.rsvpTableView.backgroundColor = .white
//        self.rsvpTableView.register(ActionItemRsvpHeaderFooterView.nib, forHeaderFooterViewReuseIdentifier: ActionItemRsvpHeaderFooterView.identifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RSVPViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return aiHeaderViewArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
     return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerObj = aiHeaderViewArray[section]
        

        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActionItemRsvpHeaderFooterView.identifier) as? ActionItemRsvpHeaderFooterView {
            
            headerView.delegate = self
            headerView.indexPath = IndexPath(row: 0, section: section)
            switch headerObj.responceEnum
            {
            case .accepted:
                headerView.updateUI(responceCount: "4 Student (19 Parents)", aiHeaderViewObj: headerObj)
                
            case .rejected:
                headerView.updateUI(responceCount: "14 Student", aiHeaderViewObj: headerObj)
                
            case .noResponce:
                headerView.updateUI(responceCount: "34 Student", aiHeaderViewObj: headerObj)

            default:
                return UIView()
            }
            
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let headerObj = aiHeaderViewArray[section]

        switch section
        {
        case 0:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                return 0
            }
        case 1:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                return 0
            }
        case 2:
            
            if headerObj.isCollapsed
            {
                return 0
            }
            else
            {
                return 0
            }
            
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
    
    
}

extension RSVPViewController : ActionItemRsvpHeaderFooterViewDelegate
{
    
    func didTapHeaderView(indexpath: IndexPath)
    {
        let headerObj = self.aiHeaderViewArray[indexpath.section]
        
        headerObj.isCollapsed = !headerObj.isCollapsed
        
        self.rsvpTableView.reloadData()
    }
    
}

