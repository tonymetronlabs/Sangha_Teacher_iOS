//
//  Constants.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/20/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation
import UIKit

struct AppColor{
    
    static let appCalendarTextPrimaryColor: UInt32 = 0x28303C
    static let appEventColor: UInt32 = 0x22B9F0
}

struct AppFont{
    
    static let appFontLight = "ProximaNova-Light"
    static let appFontLightItalic = "ProximaNova-LightIt"
    static let appFontBold = "ProximaNova-Bold"
    static let appFontBoldItalic = "ProximaNova-BoldIt"
    static let appFontSemiBold = "ProximaNova-Semibold"
    static let appFontSemiBoldItalic = "ProximaNova-SemiboldIt"
    static let appFontExtraBold = "ProximaNova-Extrabld"
    static let appFontBlack = "roximaNova-Black"
    static let appFontRegular = "ProximaNova-Regular"
    static let appFontRegularItalic = "ProximaNova-RegularIt"
    
    static let appFontCondRegular = "ProximaNovaCond-Regular"
    static let appFontCondRegularItalic = "ProximaNovaCond-RegularIt"
    static let appFontCondSemiBold = "ProximaNovaCond-Semibold"
    static let appFontCondSemiBoldItalic = "ProximaNovaCond-SemiboldIt"
    static let appFontCondLight = "ProximaNovaCond-Light"
    static let appFontCondLightItalic = "ProximaNovaCond-LightIt"
    
    
}

enum API_METHOD: String{
    
    case GET = "GET"
    case POST = "POST"
    
}

struct Messages {
    
    static let networkErrorTitle  = "Request timed out"
    
    static let networkErrorMessage  = "Something went wrong, please try again after some time."
    
    static let noInternetTitle  = "No Internet connection"
    
    static let noInternetMessage = "Please check your connection or try again later"
    
}

enum MenuItem: Int{
    
    case notifications = 0,
    autoAlert,
    classes,
    settings,
    logout
    
    var menuTitle: String{
        
        switch self {
        case .notifications:
            
            return "Notifications"
            
        case .autoAlert:
            
            return "Auto Alert"
            
        case .classes:
            
            return "Classes"
            
        case .settings:
            
            return "Settings"

        case .logout:

            return "Logout"

        }
        
    }
    
    static let menuArray: [MenuItem] = [.notifications, .autoAlert, .classes, .settings, .logout]
    
}

enum EventType : String{
    case ptm = "ptm"
    case fieldTrip = "fieldtrip"
    case reminder = "reminder"
}


enum AiType : String {
    
    case form = "approval"
    case rsvp = "rsvp"
    case toBring = "stb"
    case payment = "payment"
    case volunteer = "todo"
    case ptm = "ptm"

    var title : String {

        switch self {
        case .form:
            return "FORM"
        case .rsvp:
            return "RSVP"
        case .toBring:
            return "TO BRING"
        case .payment:
            return "PAYMENT"
        case .volunteer:
            return "VOLUNTEER"
        case .ptm:
            return "PTM"
        default:
            return ""
        }
    }

    var placeholderImageView : UIImage {

        switch self {
        case .rsvp:
            return #imageLiteral(resourceName: "students")
            break
        case .form:
            return #imageLiteral(resourceName: "note")
            break
        case .payment:
            return #imageLiteral(resourceName: "small_dollar")
            break
        case .volunteer:
            return #imageLiteral(resourceName: "hand")
            break
        case .toBring:
            return #imageLiteral(resourceName: "cart")
            break
        default:
            return #imageLiteral(resourceName: "students")
            break
        }
    }
}

enum DateFormat : String {

    case computedScheduleDate = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    case eventDetailDate = "HH:mm a, dd/MM/yy"
}

enum UserDefaultsKey : String {
    case isLogin = "isLogin"
    case accessToken = "accessToken"
}
