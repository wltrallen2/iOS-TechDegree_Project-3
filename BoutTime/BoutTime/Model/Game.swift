//
//  BoutTime.swift
//  BoutTime
//
//  Created by Walter Allen on 3/21/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import Foundation

// MARK: - Enums
//**********************************************************************
/// An enum object that represents errors that can be thrown from the Game class.
enum GameError: Error {
    case eventMissingInPlayerArray
    case insufficientData
    case gameOver
}

/// An enum object that represents the two directions that items can be moved in the game.
enum TimelineDirection: Int {
    case up = -1
    case down = 1
}

// MARK: - Game Class
//**********************************************************************
class Game {
    // MARK: -
    // MARK: Round Set-up Properties
    var numItemsPerRound: Int
    var numRounds: Int
    var numSecondsPerRound: Int
    
    // MARK: Primary Data Properties
    var events = [Event]()

    // MARK: Gameplay Properties
    var currentScore: Int = 0
    var currentRound: Int = 0
    var eventsForCurrentRound = [Event]()
    var eventsInThisRoundOrderedByPlayer = [Event]()
    var numSecondsLeftInThisRound: Int = 0
    
    // MARK: Game Timer Properties
    var timer: Timer? = nil
    
    // MARK: - Initializer
    //**********************************************************************
    /// The initializer for the game requires four parameters: the number of items per round, the number of rounds, the number of seconds per round, and the name of the plist that contains the data for the game.
    init(withNumItemsPerRound num: Int,
         andNumRounds rounds: Int,
         whereRoundsAreOfLengthInSeconds seconds: Int,
         usingDataFromPListWithName plistname: String) throws {
        
        numItemsPerRound = num
        numRounds = rounds
        numSecondsPerRound = seconds
        
        // Populate the Event array
        do {
            let eventDictionary = try PListConverter.createDictionaryFromPList(inFile: plistname)
            events.append(contentsOf: try EventDataLoader.getEventsArray(fromDictionary: eventDictionary))
        } catch let error {
            throw error
        }
        
        // Check to ensure that there is enough data for the provided parameters
        guard events.count >= (numItemsPerRound * numRounds) else {
            throw GameError.insufficientData
        }
    }
    
    // MARK: - Helper Functions
    //**********************************************************************
    /// Returns a Boolean that represents whether the player's chosen answer is correct. Additionally, this function ends the round by invalidating the timer and setting the number of seconds left in the round to zero. If the player's answer is correct, the function increments the current score by one point.
    func checkAnswerAndEndRound() -> Bool {
        timer?.invalidate()
        numSecondsLeftInThisRound = 0
        
        eventsForCurrentRound.sort()
        let correct = (eventsForCurrentRound == eventsInThisRoundOrderedByPlayer)
        
        if correct {
            currentScore += 1
        }
        
        return correct
    }

    /// Returns a Boolean that indicates whether there is another round of play left in the game.
    func hasNextRound() -> Bool {
        return currentRound < numRounds
    }
    
    /// Moves an event forward or backward one index based on the given direction. Throws an error if the given event does not exist in the current round array.
    func move(_ event: Event, oneItem direction: TimelineDirection) throws {
        guard let eventIndex = eventsInThisRoundOrderedByPlayer.firstIndex(of: event) else {
            throw GameError.eventMissingInPlayerArray
        }
        
        let swapIndex = eventIndex + direction.rawValue
        eventsInThisRoundOrderedByPlayer.swapAt(eventIndex, swapIndex)
    }
    
    /// Selects the correct number of events from the events array at random and returns a new event array with those events in random order.
    func popEventsForRound() -> [Event] {
        var eventsForRound = [Event]()
        
        for _ in 0..<numItemsPerRound {
            let randomIndex = Int.random(in: 0..<events.count)
            let eventForRound = events.remove(at: randomIndex)
            eventsForRound.append(eventForRound)
        }
        
        return eventsForRound
    }
    
   /// Starts the round by instantiating a timer using two parameters: an NSObject representing a timer target and a Selector representing the selector in that NSObject that needs to be called when the timer fires. Additionally, this function increases the count of the currentRound by 1, resets the counter for the number of seconds in the current round, checks to ensure that there is another round of play in the game, and populates an array with events for the current round.
    func startRound(withTimerTarget target: NSObject, andSelector selector: Selector) throws {
        currentRound += 1
        numSecondsLeftInThisRound = numSecondsPerRound
        
        guard currentRound <= numRounds else {
            throw GameError.gameOver
        }
        
        eventsForCurrentRound = popEventsForRound()
        eventsInThisRoundOrderedByPlayer = Array(eventsForCurrentRound)
        
        startTimer(withTarget: target, andSelector: selector)
    }
    
    /// Starts the timer using two parameters, an NSObject (the target of the timer) and a Selector (the function that should be called in the target when the timer fires). Each time the timer fires (every one second), the selector is called in the target object AND the number of seconds left in this round is decremented by one. If the number of seconds left in the round is zero, the timer is invalidated.
    func startTimer(withTarget target: NSObject, andSelector selector: Selector) {
        numSecondsLeftInThisRound = numSecondsPerRound
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if self.numSecondsLeftInThisRound <= 0 {
                self.timer?.invalidate()
            } else {
                target.performSelector(onMainThread: selector, with: nil, waitUntilDone: false)
                self.numSecondsLeftInThisRound -= 1
            }
        })
    }
}
