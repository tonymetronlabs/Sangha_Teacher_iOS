//
//  StudentNameAndImageTableViewCell.swift
//  Sangha Teacher
//
//  Created by Ashfauck on 10/12/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class StudentNameAndImageTableViewCell: UITableViewCell {

    @IBOutlet var studentNameLbl: UILabel!
    @IBOutlet var profileImageBtn: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(student:String)
    {
        self.studentNameLbl.text = student
        
        let studentNameArray = student.components(separatedBy: " ")
        
        if studentNameArray.count > 1
        {
            guard let firstLetter = studentNameArray.first?.characters.first, let secondLetter = studentNameArray[1].characters.first else { return }
            
            self.profileImageBtn.setTitle("\(firstLetter)\(secondLetter)", for: .normal)
        }else
        {
            guard let firstLetter = studentNameArray.first?.characters.first else { return }

            self.profileImageBtn.setTitle("\(firstLetter)", for: .normal)

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
