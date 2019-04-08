//
//  SplashVC.swift
//  BoutTime
//
//  Created by Walter Allen on 3/23/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit

/// SplashVC is the view controller for the first interactive screen that the player sees in the game. It controls one button that initializes a new Game and passes it to the game view controller. Currently, the view controller retrieves the constants for the game initializer from the GameControls class; however, for future iterations, these constants could be randomized or be picked by the player.
class SplashVC: UIViewController {
    
    /// IBOutlet Property connected to the play button
    @IBOutlet weak var playButton: UIButton!
    
    /// Overrides the preferred status bar style and sets as light content
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cycle Methods
    //**********************************************************************
    /// After loading, this method will set the corner radius for the play button to create a rounded rectangle.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Round the corners of the playButton
        playButton.layer.cornerRadius = 20
    }
    
    // MARK: - Navigation
    //**********************************************************************
    /// Tests the segue to ensure that it is a segue to a GameVC object, then initializes a new game and sets the game property in the GameVC object. If the game fails to initialize, the program will fail.
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameVC = segue.destination as? GameVC {
            do {
            gameVC.game = try Game(withNumItemsPerRound: GameConstants.numItemsPerRound,
                               andNumRounds: GameConstants.numRounds,
                               whereRoundsAreOfLengthInSeconds: GameConstants.numSecondsperRound,
                               usingDataFromPListWithName: GameConstants.pListName)
            } catch let error {
                print("\(error)")
                fatalError()
            }
        }
     }

}
