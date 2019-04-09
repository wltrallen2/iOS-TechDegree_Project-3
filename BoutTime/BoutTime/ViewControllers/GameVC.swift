//
//  GameVC.swift
//  BoutTime
//
//  Created by Walter Allen on 3/24/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Private Constants
//**********************************************************************
/// Reuse Identifier Constants for Cell Dequeuing
fileprivate let reuseIdentifierForSingleUpArrow = "GameCVCellSingleUp"
fileprivate let reuseIdentifierForSingleDownArrow = "GameCVCellSingleDown"
fileprivate let reuseIdentifierForDoubleArrow = "GameCVCellDouble"

/// Segue Identifier Constants
fileprivate let presentScoreVCIdentifier = "presentScoreVC"
fileprivate let presentWebVCIdentifier = "presentWebVC"

/// Image Name Constants
fileprivate let correctImageName = "next_round_success"
fileprivate let wrongImageName = "next_round_fail"
fileprivate let correctImageNameForEnd = "see_final_score_success"
fileprivate let wrongImageNameForEnd = "see_final_score_fail"

/// Audio File Name Constants
fileprivate let correctDing = "CorrectDing"
fileprivate let incorrectBuzz = "IncorrectBuzz"

/// Collection View Flow Layout Constants
fileprivate let collectionViewFlowLayoutPadding: CGFloat = 10
fileprivate let collectionViewFlowLayoutSpacing: CGFloat = 10


// MARK: - GameVC Class
//**********************************************************************
/// The GameVC class controls the visual representation of the Game object. This class is the Data Source and Delegate for the UICollectionView that it contains. Additionally, it is the Delegate for the UICollectionViewFlowLayout.
class GameVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /// Overrides the preferred status bar style and sets as light content
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - IBOutlet Properties
    //**********************************************************************
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var nextRoundImageView: UIImageView!
    
    // MARK: - Game Property
    var game: Game?
    
    
    // MARK: - Life Cycle Methods
    //**********************************************************************
    /// Once the view has loaded, this property calls the startRound method to start the first round.
    override func viewDidLoad() {
        super.viewDidLoad()
        startRound()
    }
    
    
    // MARK: - Action Methods
    //**********************************************************************
    /// If the round is active (that is, there is time left on the timer), this method will move the event in the tapped cell down one space in the player's array.
    @objc  func downArrowImageTapped(_ sender: UITapGestureRecognizer) {
        if isRoundActive() {
            moveEventIdentifiedBy(sender, inDirection: .down)
        }
    }
    
    /// If the round is over, this method will call the presentWebVC segue, which will display a WKWebView that is pointed to the event's url.
    @objc  func labelTapped(_ sender: UITapGestureRecognizer) {
        if !isRoundActive(), let event = getEventIdentifiedBy(tapGestureRecognizer: sender) {
            performSegue(withIdentifier: presentWebVCIdentifier, sender: event)
        }
    }
    
    /// If the game has another round, this method will start the next round. If the game has no more rounds, this method will call the presentScoreVC segue, which will display the score and prompt the player to play again.
    @IBAction func nextRoundButtonTapped(_ sender: UITapGestureRecognizer) {
        if game?.hasNextRound() == true {
            startRound()
        } else {
            performSegue(withIdentifier: presentScoreVCIdentifier, sender: self)
        }
    }
    
   /// If the round is active (that is, there is time left on the timer), this method will move the event in the tapped cell up one space in the player's array.
    @objc func upArrowImageTapped(_ sender: UITapGestureRecognizer) {
        if isRoundActive() {
            moveEventIdentifiedBy(sender, inDirection: .up)
        }
    }
    
    // MARK: - Navigation
    //**********************************************************************
    /// This method handles the two possible segues from a Game View Controller. In a presentScoreVC segue, the method passes the game's final score to the ScoreVC object. In a presentWebVC segue, the method passes the event's URL to the WebVC object.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == presentScoreVCIdentifier {
            if let scoreVC = segue.destination as? ScoreVC {
                scoreVC.scoreToPresent = "\(game?.currentScore ?? 0)/\(game?.numRounds ?? 0)"
            }
        } else if segue.identifier == presentWebVCIdentifier {
            if let webVC = segue.destination as? WebVC, let event = sender as? Event {
                webVC.urlToLoad = event.url
            }
        }
    }
    
    /// Unwinds to this view controller and, if unwinding from a ScoreVC instance, starts a new game.
    @IBAction func unwindToGameVC(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is ScoreVC {
            startGame()
            startRound()
        }
    }
    
    // MARK: - Shake Gesture Methods
    //**********************************************************************
    /// This method is called when the device stops shaking, and if the round is still active (i.e. there is still time left), the method will check the current answer and end the round.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && isRoundActive() {
            checkAnswerAndEndRound()
        }
    }
    
    // MARK: - UICollectionViewDataSource Methods
    //**********************************************************************
    /// Returns the number of items in the collection view based on the number of items per round in the current game object.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game?.numItemsPerRound ?? 0
    }
    
    /// Returns a cell for the collection view. This method will identify whether the cell needed is a top or bottom cell or one of the in between cell and will dequeue a cell accordingly. (Top cells only have an arrow pointing down. Bottom cells only have an arrow pointing up, and In between cells have both arrows.) The method will then add tapGestureRecognizers to the arrows as well as to the titleLabel. Then it will populate the titleLabel using the corresponding event in the events array.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let numItems = game?.numItemsPerRound ?? 0
        
        // Determine the type of cell to dequeue based on the cell's position in the collection view.
        var reuseIdentifier: String
        switch indexPath.row {
            case 0: reuseIdentifier = reuseIdentifierForSingleDownArrow
            case numItems - 1: reuseIdentifier = reuseIdentifierForSingleUpArrow
            default: reuseIdentifier = reuseIdentifierForDoubleArrow
        }

        // Dequeue a GameCVCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GameCVCell else {
            present(UIAlertController.fatalAlertController(), animated: true, completion: nil)
            fatalError()
        }

        // Assign a tapGestureRecognizer to the titleLabel.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        cell.titleLabel.addGestureRecognizer(tapGestureRecognizer)
        
        // Assign tapGestureRecognizers to the arrows as needed.
        if indexPath.row > 0 {
            let tapGestureRecognizerUp = UITapGestureRecognizer(target: self, action: #selector(upArrowImageTapped(_:)))
            cell.upArrowImageView.addGestureRecognizer(tapGestureRecognizerUp)
        }
        
        if indexPath.row < numItems - 1 {
            let tapGestureRecognizerDown = UITapGestureRecognizer(target: self, action: #selector(downArrowImageTapped(_:)))
            cell.downArrowImageView.addGestureRecognizer(tapGestureRecognizerDown)
        }
        
        // Assign an event to the cell and set the titleLabel text.
        cell.event = game?.eventsInThisRoundOrderedByPlayer[indexPath.row] ?? nil
        cell.titleLabel.text = cell.event?.description ?? ""
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    //**********************************************************************
    /// Set the UIEdgeInset for the collection view based on the private constant at the top of this file.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewFlowLayoutPadding,
                            left: collectionViewFlowLayoutPadding,
                            bottom: collectionViewFlowLayoutPadding,
                            right: collectionViewFlowLayoutPadding)
    }
    
    /// Set the minimum line spacing between sections in the collection view based on the private constant at the top of this file.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewFlowLayoutSpacing
    }
    
    /// Calculate the size for each view within the collection view based on the width and height of the device and on the private constants provided at the top of this file.
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
    //**********************************************************************
    /// Calls the checkAnswerAndEndRound() method on a Game instance. Additionally, this method hides the timer, chooses the correct image for the nextRoundImageView based on whether the player's answer is correct or not and on whether this is the last round or not, displays the nextRoundImageView, and updates the text in the instructionLabel.
    func checkAnswerAndEndRound() {
        timerLabel.isHidden = true
        
        if let correct = game?.checkAnswerAndEndRound(), let hasNextRound = game?.hasNextRound() {
            var imageName: String
            if correct {
                imageName = (hasNextRound ? correctImageName : correctImageNameForEnd)
                GameSound(forResource: correctDing, ofType: ".wav").play()
            } else {
                imageName = (hasNextRound ? wrongImageName : wrongImageNameForEnd)
                GameSound(forResource: incorrectBuzz, ofType: ".wav").play()
            }
            
            nextRoundImageView.image = UIImage(named: imageName)
        }
        
        nextRoundImageView.isHidden = false
        instructionLabel.text = "Tap a show title to learn more."
    }
    
    /// Returns a Boolean that represents whether or not there are still seconds left for game play in this round.
    func isRoundActive() -> Bool {
        let numSecondsLeft = game?.numSecondsLeftInThisRound ?? 0
        return numSecondsLeft > 0
    }
    
    /// Given a UIView instance, this method searches for the closest superview that matches class AnyClass and returns it. If none is found, the method returns nil.
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
    
    /// Returns the event associated with the GameCVCell that contains the object with the activated UITapGestureRecognizer. If UITapGestureRecognizer is not contained by a GameCVCell, the method returns nil.
    func getEventIdentifiedBy(tapGestureRecognizer: UITapGestureRecognizer) -> Event? {
        if let view = tapGestureRecognizer.view,
            let gameCVCell = findClosestSuperView(ofClass: GameCVCell.self, forView: view) as? GameCVCell {
            return gameCVCell.event
        }
        return nil
    }
    
    /// Calls the move method in a Game instance to move the event contained within a GameCVCell in the given direction.
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
    
    /// Initializes a new game object and calls the startRound() method to start the first round of game play.
    func startGame() {
        do {
            game = try Game(withNumItemsPerRound: GameConstants.numItemsPerRound,
                            andNumRounds: GameConstants.numRounds,
                            whereRoundsAreOfLengthInSeconds: GameConstants.numSecondsperRound,
                            usingDataFromPListWithName: GameConstants.pListName)
        } catch let error {
            print("\(error)")
            present(UIAlertController.fatalAlertController(), animated: true, completion: nil)
        }
    }
    
    /// Calls the startRound(withTimerTarget: andSelector:) method in a Game instance. Additionally, this method updates the view by displaying the timer and setting the text to represent the correct number of seconds in the round, setting the instruction label text, and hiding the nextRoundImageView. Finally, the method reloads the collection view data so that the correct event titles are displayed. If the startRound method fails, the program will fail as well.
    func startRound() {
        do {
            try game?.startRound(withTimerTarget: self, andSelector: #selector(updateTimerLabel))

            timerLabel.text = ":\(game?.numSecondsPerRound ?? 0)"
            timerLabel.isHidden = false
            
            instructionLabel.text = "Shake to check your answer."
            nextRoundImageView.isHidden = true
            
            self.collectionView.reloadData()
        } catch let error {
            print(error)
            present(UIAlertController.fatalAlertController(), animated: true, completion: nil)
        }
    }
    
    /// Updates the timerLabel text to match the number of seconds left in the round. If the number of seconds left in the round is zero, this method calls the checkAnswerAndEndRound() method within this class's instance. This method formats the timerLabel text ensuring that it has a leading colon (:) and that single digits have a leading zero (0).
    @objc func updateTimerLabel() {
        let numSecondsLeft = game?.numSecondsLeftInThisRound ?? 0
        if numSecondsLeft <= 0 {
            checkAnswerAndEndRound()
        } else {
            var leadString = ":"
            if numSecondsLeft <= 9 {
                leadString += "0"
            }
            timerLabel.text = "\(leadString)\(numSecondsLeft)"
        }
    }
}
