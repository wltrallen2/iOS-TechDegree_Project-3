//
//  Event.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

enum EventItem : String {
    case title
    case date
    case url
}

//FIXME: Update plist and Event struct so that date is a Date object, not just an Int.
struct Event: Comparable {
    let description: String
    let date: Int
    let url: URL
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.date == rhs.date
    }
}
