//
//  DataLoader.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

enum EventDataError: Error {
    case failureToConvertDataToEvent(object: AnyObject)
}

class EventDataLoader {
    static func getEventsArray(fromDictionary dictionary: [String: AnyObject]) throws -> [Event] {
        var events = [Event]()
                
        for eventDictionary in dictionary.values {
            guard let date = eventDictionary[EventItem.date.rawValue] as? Int,
            let description = eventDictionary[EventItem.title.rawValue] as? String,
            let urlString = eventDictionary[EventItem.url.rawValue] as? String,
            let url = URL(string: urlString) else {
                throw EventDataError.failureToConvertDataToEvent(object: eventDictionary)
            }
            
            let event = Event(description: description, date: date, url: url)
            events.append(event)
        }
        
        return events
    }
}
