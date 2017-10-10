//
//  ActionItemCollectionViewCell.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/10/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class ActionItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(aiTypeModel:ActionItemModel) -> Void
    {
        UIView.performWithoutAnimation {
            self.titleButton.setTitle(aiTypeModel.aiType.title, for: .normal)
            
            self.titleButton.setTitleColor((aiTypeModel.isSelected) ? UIColor.black : UIColor.lightGray, for: .normal)
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
