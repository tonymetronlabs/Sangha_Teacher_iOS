//
//  ActionItemRsvpHeaderFooterView.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

protocol ActionItemRsvpHeaderFooterViewDelegate
{
    func didTapHeaderView(indexpath:IndexPath)
}

class ActionItemRsvpHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet var responceCountLabel: UILabel!
    @IBOutlet var dropDownButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var legendImageView: UIImageView!
    var indexPath:IndexPath?
    var delegate:ActionItemRsvpHeaderFooterViewDelegate?
    var isCollapsed:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    func didTapHeader()
    {
        
        guard let selectedIndexPath = indexPath else {
            return
        }
        
        self.setCollapsed(collapsed: !isCollapsed)
        
        self.delegate?.didTapHeaderView(indexpath: selectedIndexPath)
    }
    
    func setCollapsed(collapsed: Bool)
    {
        self.dropDownButton?.rotate(collapsed ? 0.0 : .pi)
    }
   
    func updateUI(responceCount:String,aiHeaderViewObj:AIHeaderViewModel)
    {
        self.titleLabel.text = aiHeaderViewObj.responceEnum.title
        self.legendImageView.image = aiHeaderViewObj.responceEnum.image
        self.responceCountLabel.text = responceCount
        self.isCollapsed = aiHeaderViewObj.isCollapsed
        self.setCollapsed(collapsed: self.isCollapsed)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    

}
