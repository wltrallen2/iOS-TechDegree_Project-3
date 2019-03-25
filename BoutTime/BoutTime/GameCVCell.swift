//
//  GameCVCell.swift
//  BoutTime
//
//  Created by Walter Allen on 3/24/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit


class GameCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setForTwoArrows() {
        downArrowImageView.addConstraint(getHalfHeightConstraint(forItem: downArrowImageView))
        upArrowImageView.addConstraint(getHalfHeightConstraint(forItem: upArrowImageView))
    }
    
    func removeUpArrow() {
        upArrowImageView.removeFromSuperview()
        downArrowImageView.image = UIImage(named: "down_full")
        downArrowImageView.addConstraint(getFullHeightConstraint(forItem: downArrowImageView))
    }
    
    func removeDownArrow() {
        downArrowImageView.removeFromSuperview()
        upArrowImageView.image = UIImage(named: "up_full")
        upArrowImageView.addConstraint(getFullHeightConstraint(forItem: upArrowImageView))
    }
    
    func getHalfHeightConstraint(forItem item: Any) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item,
                                  attribute: .height,
                                  relatedBy: .equal,
                                  toItem: item,
                                  attribute: .width,
                                  multiplier: 1.0 / 1.0,
                                  constant: 0)
    }
    
    func getFullHeightConstraint(forItem item: Any) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item,
                                  attribute: .height,
                                  relatedBy: .equal,
                                  toItem: item,
                                  attribute: .width,
                                  multiplier: 2.0 / 1.0,
                                  constant: 0)

    }

}
