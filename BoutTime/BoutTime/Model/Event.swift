//
//  Event.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

// MARK: - Enum
//**********************************************************************
/// An enum representing the three parts of an Event: the title, the date, and the url.
enum EventItem : String {
    case title
    case date
    case url
}

// MARK: - Struct
//**********************************************************************
// A struct representing an Event, containing a description (or title), a date, and a url. Events are comparable by date.
struct Event: Comparable {
    let description: String
    let date: Date
    let url: URL
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.date == rhs.date
    }
}
