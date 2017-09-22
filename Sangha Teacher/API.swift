//
//  API.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/20/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import UIKit
import Foundation

class API: NSObject {
    
    #if DEBUG
    
    private static let kServerURL = "http://beta-api.sanghapp.com/v1/"
    
    #else
    
    private static let kServerURL = ""
    
    #endif
    
    static var accessToken = ""
    
    
    internal struct Login{
        
        var paramDict: Dictionary<String, Any>? = nil
        
        let URL = "http://beta-web.sanghapp.com/login"
        
        let APIMethod: API_METHOD = .POST
        
        init(withEmail email: String, password: String) {
            
            paramDict = ["email":email,"password":password]
            
        }
        
    }
    
    internal struct NowForOrg{
        
        var URL = ""
        
        var paramDict: Dictionary<String, Any>? = nil
                
        let APIMethod: API_METHOD = .GET
        
        init(withDate date: String, eventsOnly: String, rt: String, oamr: String) {
            
            var urlComponents = URLComponents(string: kServerURL + "nowfororg?")!
            
            urlComponents.queryItems = [URLQueryItem(name: "dt", value: date),
                                        URLQueryItem(name: "eo", value: eventsOnly),
                                        URLQueryItem(name: "rt", value: rt),
                                        URLQueryItem(name: "oamr", value: oamr),
                                        URLQueryItem(name: "access_token", value: API.accessToken)]
            
            
            URL = (urlComponents.url?.absoluteString)!
        }
        
        
        
    }

}
