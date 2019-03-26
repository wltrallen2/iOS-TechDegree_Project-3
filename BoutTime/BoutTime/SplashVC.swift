//
//  SplashVC.swift
//  BoutTime
//
//  Created by Walter Allen on 3/23/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playButton.layer.cornerRadius = 25
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameVC = segue.destination as? GameVC else {
            fatalError()
        }
        
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
