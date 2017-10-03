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
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
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
        
    }
    
    // MARK: - Methods
    
    func navigateToHome() {
        
        //let sideMenuNavController = self.storyboard?.instantiateViewController(withIdentifier: "SBEvents") as! UINavigationController
        
        let sideMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SBLeft") as! LeftSideMenuViewController
        
        let eventsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SBEvents") as! UINavigationController
        
        let sideMenuController = SlideMenuController(mainViewController: eventsViewController, leftMenuViewController: sideMenuVC)
        
        sideMenuController.addLeftGestures()
        
        self.navigationController?.setViewControllers([sideMenuController], animated: true)
    }
    
    fileprivate func getLogin(){
        
        guard let emailId = self.emailIdTextField.text, !emailId.isEmpty, !emailId.removeWhiteSpace.isEmpty  else {
            
            self.showAlert(withTitle: "Enter Email-Id", message: "")
            
            return
            
        }
        
        guard let validEmail = self.emailIdTextField.text, validEmail.isValidEmail else {
            
            self.showAlert(withTitle: "Enter valid Email-Id", message: "")
            
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty, !password.removeWhiteSpace.isEmpty  else {
            
            self.showAlert(withTitle: "Enter Password", message: "")
            
            return
            
        }
        
        let loginApi = API.Login.init(withEmail: validEmail , password: password)
        
        APIHandler.sharedInstance.initWithAPIUrl(loginApi.URL, method: loginApi.APIMethod, params: loginApi.paramDict, currentView: self) { (success, response) in
            
            if success {
                
                if response?["status"] as! Int == 200{
                    
                    print(response ?? "No dict")
                    
                    API.accessToken = response?["at"] as! String
                    
                    self.navigateToHome()
                    
                }else {
                    
                    self.showAlert(withTitle: response?["message"] as? String ?? "No resposne", message:"")
                }
            }else{
                
                self.showAlert(withTitle: Messages.networkErrorTitle, message: Messages.networkErrorMessage)
            }
        }
        
        
    }
    
    // MARK: - Button Action
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.getLogin()
        
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailIdTextField{
            
            self.passwordTextField.becomeFirstResponder()
            
        }else if textField == self.passwordTextField{
            
            self.passwordTextField.resignFirstResponder()
            
        }
        
        return true
        
    }
    
}
