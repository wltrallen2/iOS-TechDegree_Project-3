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

fileprivate let presentScoreVCIdentifier = "presentScoreVC"

fileprivate let correctButtonName = "next_round_success"
fileprivate let wrongButtonName = "next_round_fail"

fileprivate let collectionViewFlowLayoutPadding: CGFloat = 10
fileprivate let collectionViewFlowLayoutSpacing: CGFloat = 10

class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startRound()
        nextRoundButton.layer.cornerRadius = 20
    }
    
    // MARK: - Action Methods
    
    @IBAction func upArrowImageTapped(_ sender: UITapGestureRecognizer) {
        moveEventIdentifiedBy(sender, inDirection: .up)
    }
    
    @IBAction func downArrowImageTapped(_ sender: UITapGestureRecognizer) {
        moveEventIdentifiedBy(sender, inDirection: .down)
    }
    
    @IBAction func labelTapped(_ sender: UITapGestureRecognizer) {
        if let event = getEventIdentifiedBy(tapGestureRecognizer: sender) {
            print(event.url) //FIXME: Redirect to URL/WebView
        }
    }
    
    @IBAction func nextRoundButtonTapped(_ sender: Any) {
        if game?.hasNextRound() == true {
            do {
                try game?.startRound()
                self.collectionView.reloadData()
                startRound()
            } catch let error {
                print(error)
            }
        } else {
            performSegue(withIdentifier: presentScoreVCIdentifier, sender: self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == presentScoreVCIdentifier {
            guard let scoreVC = segue.destination as? ScoreVC else { fatalError() }
            scoreVC.scoreToPresent = "\(game?.currentScore ?? 0)/\(game?.numRounds ?? 0)"
        }
    }

    // MARK: - Shake Gesture Methods
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            checkAnswerAndEndRound()
        }
    }
    
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game?.numItemsPerRound ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let numItems = game?.numItemsPerRound ?? 0
        
        let reuseIdentifier: String
        // FIXME: Use switch statement here
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
    
    func findClosestSuperView(ofClass classToTest: AnyClass, forView view: UIView) -> UIView? {
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
    
    func getEventIdentifiedBy(tapGestureRecognizer: UITapGestureRecognizer) -> Event? {
        if let view = tapGestureRecognizer.view,
            let gameCVCell = findClosestSuperView(ofClass: GameCVCell.self, forView: view) as? GameCVCell {
            return gameCVCell.event
        }
        
        return nil
    }
    
    func moveEventIdentifiedBy(_ tapGestureRecognizer: UITapGestureRecognizer, inDirection direction: TimelineDirection) {
        if let event = getEventIdentifiedBy(tapGestureRecognizer: tapGestureRecognizer) {
            do {
                try game?.move(event, oneItem: direction)
            } catch let error {
                print(error)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func startRound() {
        // FIXME: Actually start the timer.
        timerLabel.isHidden = false
        instructionLabel.text = "Shake to check your answer."
        nextRoundButton.isHidden = true
        self.collectionView.reloadData()
    }
    
    func checkAnswerAndEndRound() {
        // FIXME: Stop the timer.
        
        // FIXME: What to do if there is no final round?
        var nextRoundButtonTitle = "  Next Round"
        if game?.hasNextRound() == false {
            nextRoundButtonTitle = "  See Final Score"
        }
        
        if game?.checkAnswerAndEndRound() == true {
            nextRoundButton.backgroundColor = UIColor(red: 0.338, green: 0.839, blue: 0.256, alpha: 1.0)
            nextRoundButton.setTitle("✔️" + nextRoundButtonTitle, for: .normal)
        } else {
            nextRoundButton.backgroundColor = UIColor.red
            nextRoundButton.setTitle("✘" + nextRoundButtonTitle, for: .normal)
        }
        
        timerLabel.isHidden = true
        instructionLabel.text = "Tap a show title to learn more."
        nextRoundButton.isHidden = false
    }
}
