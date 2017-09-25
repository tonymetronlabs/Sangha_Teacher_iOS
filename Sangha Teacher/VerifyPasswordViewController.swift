//
//  VerifyPasswordViewController.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/21/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit

class VerifyPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    var emailId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.passwordTextField.becomeFirstResponder()
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
 
    
    //MARK: - API Call 
    
    fileprivate func getLogin(){
        
        guard let password = self.passwordTextField.text, !password.isEmpty, !password.removeWhiteSpace.isEmpty  else {
            
            self.showAlert(withTitle: "Enter Password", message: "")
            
            return
            
        }
        
        self.verifyButton.isUserInteractionEnabled = false
        
        let loginApi = API.Login.init(withEmail: self.emailId , password: password)
        
        APIHandler.sharedInstance.initWithAPIUrl(loginApi.URL, method: loginApi.APIMethod, params: loginApi.paramDict, currentView: self) { (success, response) in
            
            if success {
                
                self.verifyButton.isUserInteractionEnabled = true
                
                if response?["status"] as! Int == 200{
                    
                    print(response ?? "No dict")
                    
                    API.accessToken = response?["at"] as! String
                    
                    self.passwordTextField.resignFirstResponder()
                    
                    self.performSegue(withIdentifier: "tabBarSegue", sender: nil)
                    
                }else {
                    
                    self.showAlert(withTitle: response?["message"] as? String ?? "No resposne", message:"")
                }
            }else{
                
                self.verifyButton.isUserInteractionEnabled = true
                self.showAlert(withTitle: Messages.networkErrorTitle, message: Messages.networkErrorMessage)
            }
        }
    }
    

    //MARK: - Button Action
    
    @IBAction func verifyButtonAction(_ sender: Any) {
        
        self.getLogin()
    }
}


extension VerifyPasswordViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.getLogin()
        
        return true
    }
    
}
