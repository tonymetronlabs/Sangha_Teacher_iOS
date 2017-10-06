//
//  APIHandler.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/20/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit
import SVProgressHUD

class APIHandler: NSObject {

    static let sharedInstance = APIHandler()
    
    //MARK:- Reachability Check Method
    
    func hasReachability() -> Bool{
        
        let reachability = Reachability()!
        
        return reachability.isReachable
    }
    
    
    //MARK:- Service Request and Response
    
    func initWithAPIUrl(_ urlString: String, method: API_METHOD, params: Dictionary<String, Any>?, currentView: UIViewController?, completionHandler: @escaping (Bool, Dictionary<String, Any>?, Data?) -> Void){
        
        if self.hasReachability() { // Need to check Reachability
            
            if currentView != nil {
                
                DispatchQueue.main.async {
                    
                    SVProgressHUD.show()
                }
            }
            
            let url: URL = URL(string: "" + urlString)!
            
            print("urlString and Param.... \(url)....\(params)")
            
            var request = URLRequest(url: url)
            
            request.httpMethod = method.rawValue
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if params != nil {
                request.httpBody = try? JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            }
            
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                guard let data = data, error == nil else {
                    
                    print("error=\(error)")
                    
                    DispatchQueue.main.async {
                        
                        if currentView != nil {
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                    }
                    
                    completionHandler(false, nil, nil)
                    
                    return
                    
                }
                
                //if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                //ICUtils.showAlertWithTitle("Response Code :" + String(httpStatus.statusCode), message: "Code", inVC: currentView)
                
                //}else{
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        
                        DispatchQueue.main.async(execute: {
                            
                            if currentView != nil {
                                
                                SVProgressHUD.dismiss()
                                
                            }
                            
                            completionHandler(true, json as Dictionary<String, Any>,data)
                        })
                        
                        
                    }
                    
                } catch let error {
                    
                    print("error..desc\(error.localizedDescription)")
                    
                    DispatchQueue.main.async(execute: {
                        
                        if currentView != nil {
                            
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        completionHandler(false, nil,nil)
                        
                    })
                    
                }
                
                
                }.resume()
            
        }else{
            
            DispatchQueue.main.async(execute: {
                
                if currentView != nil {
                    
                    currentView?.showAlert(withTitle: Messages.noInternetTitle, message: Messages.noInternetMessage)
                }
            })
            
        }
        
        
    }
    
}


