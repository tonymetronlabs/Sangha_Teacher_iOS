//
//  HeaderView.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/28/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    var view: UIView!
    
    @IBOutlet var backGroundView: UIView!
    
    //@IBOutlet var headerImageView: UIImageView!
    
    @IBOutlet var headerLabel: UILabel!
    
    @IBInspectable var title:String? {
        
        get {
            return ""
        }
        
        set {
            
            if newValue != "" {
                self.headerLabel.text = newValue
            }
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    func xibSetup(){
        
        addSubview(loadViewFromNib())
    }
    
    func loadViewFromNib() -> UIView {
        
        let view = HeaderView.nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
