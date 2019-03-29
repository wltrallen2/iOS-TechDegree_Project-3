//
//  ScoreVC.swift
//  BoutTime
//
//  Created by Walter Allen on 3/25/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController {
    
    var scoreToPresent: String = ""
    @IBOutlet weak var scoreLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text? = scoreToPresent
    }
    
    // MARK: - Action Methods
    
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
