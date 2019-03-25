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
    

}
