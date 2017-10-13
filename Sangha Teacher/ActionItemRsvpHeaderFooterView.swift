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
    var headerObj:AIHeaderViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        
        self.contentView.layerDrawForView(position: .LAYER_TOP, color: .gray, layerThickness: 1.0)
        self.contentView.layerDrawForView(position: .LAYER_BOTTOM, color: .gray, layerThickness: 1.0)
        
    }
    
    func didTapHeader()
    {
        guard let selectedIndexPath = indexPath else {
            return
        }
        
        self.delegate?.didTapHeaderView(indexpath: selectedIndexPath)
    }
   
    func updateUI(responceCount:String,aiHeaderViewObj:AIHeaderViewModel)
    {
        self.titleLabel.text = aiHeaderViewObj.responceEnum.title
        self.legendImageView.image = aiHeaderViewObj.responceEnum.image
        self.responceCountLabel.text = responceCount
        self.dropDownButton.setImage(aiHeaderViewObj.isCollapsed ? #imageLiteral(resourceName: "down-arrow") : #imageLiteral(resourceName: "up_arrow"), for: .normal)
        headerObj = aiHeaderViewObj
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    

}
