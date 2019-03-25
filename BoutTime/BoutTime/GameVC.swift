//
//  GameVC.swift
//  BoutTime
//
//  Created by Walter Allen on 3/24/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifierForSingleUpArrow = "GameCVCellSingleUp"
fileprivate let reuseIdentifierForSingleDownArrow = "GameCVCellSingleDown"
fileprivate let reuseIdentifierForDoubleArrow = "GameCVCellDouble"


fileprivate let collectionViewFlowLayoutPadding: CGFloat = 10
fileprivate let collectionViewFlowLayoutSpacing: CGFloat = 10

//FIXME: Refractor with data from game
fileprivate let numItems = 4

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    
    
    @IBAction func upArrowImageTapped(_ sender: Any) {
    }
    
    @IBAction func downArrowImageTapped(_ sender: Any) {
    }
    
    @IBAction func labelTapped(_ sender: Any) {
    }
    
    @IBAction func nextRoundImageTapped(_ sender: Any) {
    }

    // MARK: - Shake Gesture Methods
    
    /* FIXME: Do I need this code?
    override func becomeFirstResponder() -> Bool {
        return true
    }*/
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            //FIXME: Add code here
        }
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier: String
        if indexPath.row == 0 {
            reuseIdentifier = reuseIdentifierForSingleUpArrow
        } else if indexPath.row == numItems - 1 {
            reuseIdentifier = reuseIdentifierForSingleDownArrow
        } else {
            reuseIdentifier = reuseIdentifierForDoubleArrow
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GameCVCell else { fatalError() }

        
        cell.backgroundColor = UIColor.red
        cell.titleLabel.text = "Musical Name Goes Here: This is included for a really long muscial name test."
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewFlowLayoutPadding,
                            left: collectionViewFlowLayoutPadding,
                            bottom: collectionViewFlowLayoutPadding,
                            right: collectionViewFlowLayoutPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewFlowLayoutSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let doublePadding = collectionViewFlowLayoutPadding * 2
        let numSpaces = CGFloat(integerLiteral: numItems - 1)
        let totalSpaceBetweenItems = collectionViewFlowLayoutSpacing * numSpaces
        
        let width = collectionView.bounds.width - doublePadding
        let height = (collectionView.bounds.height - (doublePadding + totalSpaceBetweenItems)) / 4
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
}
