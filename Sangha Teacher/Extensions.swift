//
//  Extensions.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/20/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex:UInt32, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

//MARK: - UIViewController Extension

extension UIViewController {
    
    func showAlert(withTitle title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - String Extension

extension String {
    
    var removeWhiteSpace: String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var isValidEmail: Bool{
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        
    }
    
    func toDateFromString(dateFormat:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateFormat = dateFormat
        
        guard dateFormat != "HH:mm:ss" else {
            let dateString = (self == "00:00:00" || self == "") ? Date().toString(dateFormat: dateFormat) : self
            return dateFormatter.date(from: dateString)!
        }
        
        let dateString = (self == "00-00-0000" ||  self == "0000-00-00" || self == "" ) ? Date().toString(dateFormat: dateFormat) : self
        
        return dateFormatter.date(from: dateString)!
    }
    
}

extension Date{
    
    func toString(dateFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
                
        dateFormatter.dateFormat = dateFormat
        
        return (dateFormatter.string(from: self))
    }
}

//MARK: - UINavigationBar Extension

extension UINavigationBar {
    
    func transparentBackground()  {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.isUserInteractionEnabled = true
    }
    
    func nilTransparentBackground()  {
        self.setBackgroundImage(nil, for: .default)
        self.isTranslucent = false
    }
}

extension UINavigationController {
    
    @IBInspectable var isBarTransparent:Bool {
        set {
            self.navigationBar.transparentBackground()
        }
        get {
            return false
        }
    }
}

//MARK: - UIView Extension

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}


//MARK: - UITextField Extension

extension UITextField {
    
    @IBInspectable public var leftPadding: CGFloat {
        set {
            if (newValue > 0) {
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 1))
                leftView = paddingView;
                leftViewMode = .always
            }
        }
        get {
            return 0.0
        }
    }
    
    @IBInspectable public var rightPadding: CGFloat {
        set {
            if (newValue > 0) {
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 1))
                rightView = paddingView;
                rightViewMode = .always
                
            }
        }
        get {
            return 0.0
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        
        set (newValue) {
            self.textFieldView(textField: self, image: newValue!,whichSide: 2)
        }
        get {
            return UIImage()
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        
        set (newValue) {
            self.textFieldView(textField: self, image: newValue!,whichSide: 1)
        }
        get {
            return UIImage()
        }
    }
    
    @IBInspectable var isNeedBottomLayer:Bool {
        set {
            self.setBottomBorder()
        }
        get {
            return false
        }
    }
    
    @IBInspectable var bottomLayerBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    func textFieldView(textField:UITextField,image: UIImage,whichSide:Int) -> Void {
        
        let txtImgView : UIView = UIView(frame:CGRect(x: 0, y: 0, width: textField.frame.size.height, height:textField.frame.size.height ) )
        
        let button = UIButton(type: UIButtonType.custom)
        
        button.frame = CGRect(x: 0, y: 0, width: 20, height:20)
        
        button.center = txtImgView.center
        
        button.setImage(image, for: .normal)
        
        txtImgView.backgroundColor = UIColor.white
        
        if whichSide == 1 // Left Side Image
        {
            textField.leftView=txtImgView
            textField.leftViewMode=UITextFieldViewMode.always
            textField.leftView?.isUserInteractionEnabled = true
            button.tag = 1
        }
        else if whichSide == 2 // Right Side Image
        {
            textField.rightView=txtImgView
            textField.rightViewMode=UITextFieldViewMode.always
            textField.rightView?.isUserInteractionEnabled = true
            button.tag = 2
        }
        
        button.contentMode = UIViewContentMode.center
        
        //button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        txtImgView.addSubview(button)
        
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
