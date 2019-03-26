//
//  BoutTime.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

enum GameError: Error {
    case eventMissingInPlayerArray
    case insufficientData
    case gameOver
}

enum TimelineDirection: Int {
    case up = -1
    case down = 1
}

class Game {
    var numItemsPerRound: Int
    var numRounds: Int
    var numSecondsPerRound: Int
    
    var events:[Event]
    
    var currentRound: Int
    var eventsForCurrentRound:[Event]
    var eventsInThisRoundOrderedByPlayer: [Event]
    
    init(withNumItemsPerRound num: Int,
         andNumRounds rounds: Int,
         whereRoundsAreOfLengthInSeconds seconds: Int,
         usingDataFromPListWithName plistname: String) throws {
        
        numItemsPerRound = num
        numRounds = rounds
        numSecondsPerRound = seconds
        
        events = [Event]()
        do {
            let eventDictionary = try PListConverter.createDictionaryFromPList(inFile: plistname)
            events.append(contentsOf: try EventDataLoader.getEventsArray(fromDictionary: eventDictionary))
        } catch let error {
            throw error
        }
        
        guard events.count >= (numItemsPerRound * numRounds) else {
            throw GameError.insufficientData
        }
        
        currentRound = 1
        eventsForCurrentRound = [Event]()
        eventsInThisRoundOrderedByPlayer = [Event]()
        
        do {
            try startRound()
        } catch let error {
            throw error
        }
    }
    
    func startRound() throws {
        guard currentRound <= numRounds else {
            throw GameError.gameOver
        }
        
        eventsForCurrentRound = popEventsForRound()
        eventsInThisRoundOrderedByPlayer = Array(eventsForCurrentRound)
        
        //FIXME: Start timer?
    }
    
    func popEventsForRound() -> [Event] {
        var eventsForRound = [Event]()
        
        for _ in 0..<numItemsPerRound {
            let randomIndex = Int.random(in: 0..<events.count)
            let eventForRound = events.remove(at: randomIndex)
            eventsForRound.append(eventForRound)
        }
        
        return eventsForRound
    }
    
    func move(_ event: Event, oneItem direction: TimelineDirection) throws {
        guard let eventIndex = eventsInThisRoundOrderedByPlayer.firstIndex(of: event) else {
            throw GameError.eventMissingInPlayerArray
        }
        
        let swapIndex = eventIndex + direction.rawValue
        eventsInThisRoundOrderedByPlayer.swapAt(eventIndex, swapIndex)
    }
    
    func hasNextRound() -> Bool {
        return currentRound <= numRounds
    }
    
    func checkAnswerAndEndRound() -> Bool {
        currentRound += 1
        
        eventsForCurrentRound.sort()
        return eventsForCurrentRound == eventsInThisRoundOrderedByPlayer
    }
}
