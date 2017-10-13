//
//  ActionItemVolunteerHeaderFooterView.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/12/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

protocol ActionItemVolunteerHeaderFooterDelegate {
    
    func didTapVolunteerHeaderView(indexpath: IndexPath)
}

class ActionItemVolunteerHeaderFooterView: UITableViewHeaderFooterView {


    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var dropDownButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    var indexPath:IndexPath?
    var delegate:ActionItemVolunteerHeaderFooterDelegate?

    
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
        
        self.delegate?.didTapVolunteerHeaderView(indexpath: selectedIndexPath)
    }
    
    func updateUI(detail:String,title:String,isCollapsed:Bool)
    {
        self.titleLabel.text = title
        self.detailLabel.text = detail

        self.dropDownButton.setImage(isCollapsed ? #imageLiteral(resourceName: "down-arrow") : #imageLiteral(resourceName: "up_arrow"), for: .normal)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
