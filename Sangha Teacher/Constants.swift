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
    
    static let appFontUltraLight = "AvenirNext-UltraLight"
    static let appFontUltraLightItalic = "AvenirNext-UltraLightItalic"
    static let appFontBold = "AvenirNext-Bold"
    static let appFontBoldItalic = "AvenirNext-BoldItalic"
    static let appFontDemiBold = "AvenirNext-DemiBold"
    static let appFontDemiBoldItalic = "AvenirNext-DemiBoldItalic"
    static let appFontMedium = "AvenirNext-Medium"
    static let appFontHeavyItalic = "AvenirNext-HeavyItalic"
    static let appFontHeavy = "AvenirNext-Heavy"
    static let appFontItalic = "AvenirNext-Italic"
    static let appFontRegular = "AvenirNext-Regular"
    static let appFontMediumItalic = "AvenirNext-MediumItalic"
    
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
