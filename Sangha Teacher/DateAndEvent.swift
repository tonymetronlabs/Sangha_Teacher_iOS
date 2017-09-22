//
//  DateAndEvent.swift
//  Sangha Teacher
//
//  Created by Ezhil on 9/22/17.
//  Copyright © 2017 Sangha. All rights reserved.
//

import Foundation

public class DateAndEvent {
    public var date: Date?
    public var event: Events?
    
    required public init?(with date: Date, event: Events) {
        
        self.date = date
        self.event = event
        
    }
    
}
