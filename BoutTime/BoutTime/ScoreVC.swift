//
//  ScoreVC.swift
//  BoutTime
//
//  Created by Walter Allen on 3/25/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit

/// The ScoreVC class represents the view controller that controls the views responsible for displaying the player's score and for prompting the user to play again.
class ScoreVC: UIViewController {
    
    // Property representing the score that will be presented to the player
    var scoreToPresent: String = ""
    
    // Property representing the label that will display the score
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Life Cycle Methods
    //**********************************************************************
    /// Once the view has loaded, this method will change the text in the scoreLabel to match the String in the scoreToPresent property, which should be set during the segue to this view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text? = scoreToPresent
    }
    
    // MARK: - Action Methods
    //**********************************************************************
    /// When the playAgain image is tapped, this method will initialize a new instance of the Game class and pass it to the GameVC's game property. Then, this method calls the gameVC's startRound() method and dismisses itself.
    @IBAction func playAgainImageTapped(_ sender: Any) {
        if let gameVC = self.presentingViewController as? GameVC {
            do {
                gameVC.game = try Game(withNumItemsPerRound: GameConstants.numItemsPerRound,
                                       andNumRounds: GameConstants.numRounds,
                                       whereRoundsAreOfLengthInSeconds: GameConstants.numSecondsperRound,
                                       usingDataFromPListWithName: GameConstants.pListName)
                gameVC.startRound()
            } catch let error {
                print("\(error)")
                fatalError()
            }

            dismiss(animated: true, completion: nil )
        }
    }
}
