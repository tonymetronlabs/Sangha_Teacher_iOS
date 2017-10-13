//
//  StudentResponceTableViewCell.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/11/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class StudentResponceTableViewCell: UITableViewCell {

    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var studentNameLbl: UILabel!
    @IBOutlet var onDateLbl: UILabel!
    @IBOutlet var channelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(responses:VolunteerResponses)
    {
        
        
        self.onDateLbl.text = "0n " + (responses.luTime?.toDateFromString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").toString(dateFormat: "dd/MM/yy hh:mm a"))!

        self.studentNameLbl.text = responses.studentName

        guard let studentNameArray = responses.studentName?.components(separatedBy: " ") else { return }
        

        
        if studentNameArray.count > 0
        {
            guard let firstLetter = studentNameArray.first?.characters.first, let secondLetter = studentNameArray[1].characters.first else { return }
            
            self.profileImageButton.setTitle("\(firstLetter)\(secondLetter)", for: .normal)
            
        }else
        {
            guard let firstLetter = studentNameArray.first?.characters.first else { return }
            
            self.profileImageButton.setTitle("\(firstLetter)", for: .normal)
            
        }
        
        
        
    }
    
    func updateUI(acceptsObj:AcceptsResponses)
    {
        
        self.onDateLbl.text = "0n " + (acceptsObj.luTime?.toDateFromString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").toString(dateFormat: "dd/MM/yy hh:mm a"))!

        self.studentNameLbl.text = acceptsObj.studentName
        
        guard let studentNameArray = acceptsObj.studentName?.components(separatedBy: " ") else { return }
        
        if studentNameArray.count > 0
        {
            guard let firstLetter = studentNameArray.first?.characters.first, let secondLetter = studentNameArray[1].characters.first else { return }
            
            self.profileImageButton.setTitle("\(firstLetter)\(secondLetter)", for: .normal)

        }else
        {
            guard let firstLetter = studentNameArray.first?.characters.first else { return }
            
            self.profileImageButton.setTitle("\(firstLetter)", for: .normal)
            
        }
        
        
    }
    
    func updateUI(acceptsObj:PaymentAcceptsResponses)
    {
        
        self.onDateLbl.text = "0n " + (acceptsObj.luTime?.toDateFromString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").toString(dateFormat: "dd/MM/yy hh:mm a"))!
        
        self.studentNameLbl.text = acceptsObj.studentName
        
        guard let studentNameArray = acceptsObj.studentName?.components(separatedBy: " ") else { return }
        
        if studentNameArray.count > 0
        {
            guard let firstLetter = studentNameArray.first?.characters.first, let secondLetter = studentNameArray[1].characters.first else { return }
            
            self.profileImageButton.setTitle("\(firstLetter)\(secondLetter)", for: .normal)
            
        }else
        {
            guard let firstLetter = studentNameArray.first?.characters.first else { return }
            
            self.profileImageButton.setTitle("\(firstLetter)", for: .normal)
            
        }
        
        
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var cellSize:CGFloat {
        return 81.0
    }
}
