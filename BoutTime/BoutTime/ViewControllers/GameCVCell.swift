//
//  GameCVCell.swift
//  BoutTime
//
//  Created by Walter Allen on 3/24/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit

/// The GameCVCell class represents a GameCV cell and includes properties connected to the cell's title label, up and down arrow image views, and the event instance assigned to the cell.
class GameCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    var event: Event?
}
