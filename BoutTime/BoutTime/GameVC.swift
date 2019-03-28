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

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    
    
    @IBAction func upArrowImageTapped(_ sender: UITapGestureRecognizer) {
        move(eventForTapGestureRecognizer: sender, inDirection: .up)
    }
    
    @IBAction func downArrowImageTapped(_ sender: UITapGestureRecognizer) {
        move(eventForTapGestureRecognizer: sender, inDirection: .down)
    }
    
    @IBAction func labelTapped(_ sender: UITapGestureRecognizer) {
        if let event = getEventFor(tapGestureRecognizer: sender) {
            print(event.url) //FIXME: Redirect to URL/WebView
        }
    }
    
    @IBAction func nextRoundImageTapped(_ sender: Any) {
        print("nextRound")
    }

    // MARK: - Shake Gesture Methods
    
    /* FIXME: Do I need this code?
    override func becomeFirstResponder() -> Bool {
        return true
    }*/
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            //FIXME: Add code here
            print("Shake")
        }
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game?.numItemsPerRound ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let numItems = game?.numItemsPerRound ?? 0
        
        let reuseIdentifier: String
        if indexPath.row == 0 {
            reuseIdentifier = reuseIdentifierForSingleDownArrow
        } else if indexPath.row == numItems - 1 {
            reuseIdentifier = reuseIdentifierForSingleUpArrow
        } else {
            reuseIdentifier = reuseIdentifierForDoubleArrow
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GameCVCell else { fatalError() }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        cell.titleLabel.addGestureRecognizer(tapGestureRecognizer)
        
        if indexPath.row > 0 {
            let tapGestureRecognizerUp = UITapGestureRecognizer(target: self, action: #selector(upArrowImageTapped(_:)))
            cell.upArrowImageView.addGestureRecognizer(tapGestureRecognizerUp)
        }
        
        if indexPath.row < numItems - 1 {
            let tapGestureRecognizerDown = UITapGestureRecognizer(target: self, action: #selector(downArrowImageTapped(_:)))
            cell.downArrowImageView.addGestureRecognizer(tapGestureRecognizerDown)
        }
        
        cell.event = game?.eventsInThisRoundOrderedByPlayer[indexPath.row] ?? nil
        cell.titleLabel.text = cell.event?.description ?? ""
        
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
        let numItems = game?.numItemsPerRound ?? 0
        let numSpaces = CGFloat(integerLiteral: numItems - 1)
        let totalSpaceBetweenItems = collectionViewFlowLayoutSpacing * numSpaces
        
        let width = collectionView.bounds.width - doublePadding
        let height = (collectionView.bounds.height - (doublePadding + totalSpaceBetweenItems)) / 4
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    // MARK: - Helper Methods
    
    func findClosestSuperView(ofClass classToTest: AnyClass, ofView view: UIView) -> UIView? {
        var viewToTest: UIView = view
        while true {
            if let superview = viewToTest.superview {
                if superview.isKind(of: classToTest) {
                    return superview
                } else {
                    viewToTest = superview
                }
            } else {
                return nil
            }
        }
    }
    
    func getEventFor(tapGestureRecognizer: UITapGestureRecognizer) -> Event? {
        if let view = tapGestureRecognizer.view,
            let gameCVCell = findClosestSuperView(ofClass: GameCVCell.self, ofView: view) as? GameCVCell {
            return gameCVCell.event
        }
        
        return nil
    }
    
    func move(eventForTapGestureRecognizer tapGestureRecognizer: UITapGestureRecognizer, inDirection direction: TimelineDirection) {
        if let event = getEventFor(tapGestureRecognizer: tapGestureRecognizer) {
            do {
                try game?.move(event, oneItem: direction)
            } catch let error {
                print(error)
            }
            
            self.collectionView.reloadData()
        }
    }
}
