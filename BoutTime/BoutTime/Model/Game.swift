//
//  BoutTime.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

enum GameError: Error {
    case insufficientData
}

class Game {
    var numItemsPerRound: Int
    var numRounds: Int
    var numSecondsPerRound: Int
    
    var events:[Event]
    var eventsForCurrentRound:[Event]
    
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
        
        eventsForCurrentRound = [Event]()
        startRound()
    }
    
    func startRound() {
        eventsForCurrentRound = popEventsForRound()
        
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
    
    func checkForCorrectness(usingProposedAnswer proposedAnswer: [Event]) -> Bool {
        eventsForCurrentRound.sort()
        return eventsForCurrentRound == proposedAnswer
    }
}
