//
//  DataLoader.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

// MARK: - Enum
//**********************************************************************
/// An enum representing errors that can be thrown from the EventDataLoader class.
enum EventDataError: Error {
    case failureToConvertDataToEvent(object: AnyObject)
}

// MARK: - EventDataLoader Class
//**********************************************************************
/// This class contains one static function that accepts one parameter: a dictionary of String keys to AnyObject values, and that returns an array of Event structs. This class can throw an error if data from the dictionary cannot be converted to an Event struct.
class EventDataLoader {
    static func getEventsArray(fromDictionary dictionary: [String: AnyObject]) throws -> [Event] {
        var events = [Event]()
                
        for eventDictionary in dictionary.values {
            guard let date = eventDictionary[EventItem.date.rawValue] as? Date,
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
