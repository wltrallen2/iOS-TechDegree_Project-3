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
        //FIXME: Add code
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
