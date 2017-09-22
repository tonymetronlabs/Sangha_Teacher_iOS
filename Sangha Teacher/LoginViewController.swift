//
//  LoginViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/21/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is VerifyPasswordViewController {
            
            let verifyPasswordVC = segue.destination as! VerifyPasswordViewController
            
            verifyPasswordVC.emailId = sender as! String
        }
        
    }
    
    // MARK: - Methods
    
    fileprivate func emailIdValidation(){
        
        guard let emailId = self.emailIdTextField.text, !emailId.isEmpty, !emailId.removeWhiteSpace.isEmpty  else {
            
            self.showAlert(withTitle: "Enter Email-Id", message: "")
            
            return
            
        }
        
        guard let validEmail = self.emailIdTextField.text, validEmail.isValidEmail else {
            
            self.showAlert(withTitle: "Enter valid Email-Id", message: "")
            
            return
        }
        
        
        
        self.performSegue(withIdentifier: "passwordSegue", sender: validEmail)
    }
    
    // MARK: - Button Action
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        self.emailIdTextField.resignFirstResponder()
        
        self.emailIdValidation()
        
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.emailIdTextField.resignFirstResponder()
        
        self.emailIdValidation()
        
        return true
        
    }
    
}
