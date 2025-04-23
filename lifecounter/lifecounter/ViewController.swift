//
//  ViewController.swift
//  lifecounter
//
//  Created by whosyihan on 4/21/25.
//

import UIKit

class ViewController: UIViewController {
    
    // Player 1 UI Elements
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player1LifeLabel: UILabel!
    @IBOutlet weak var player1PlusButton: UIButton!
    @IBOutlet weak var player1MinusButton: UIButton!
    @IBOutlet weak var player1Plus5Button: UIButton!
    @IBOutlet weak var player1Minus5Button: UIButton!
    
    // Player 2 UI Elements
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player2LifeLabel: UILabel!
    @IBOutlet weak var player2PlusButton: UIButton!
    @IBOutlet weak var player2MinusButton: UIButton!
    @IBOutlet weak var player2Plus5Button: UIButton!
    @IBOutlet weak var player2Minus5Button: UIButton!
    @IBOutlet weak var message: UILabel!
    var player1Life = 20
    var player2Life = 20
    
    override func viewDidLoad() {
            super.viewDidLoad()
            player1Life = 20
            player2Life = 20
            player1LifeLabel.text = "20"
            player2LifeLabel.text = "20"
            message.isHidden = true
        }
    // Game state
    private func updateLifeLabels() {
        player1LifeLabel.text = "\(player1Life)"
        player2LifeLabel.text = "\(player2Life)"
    }
    
    private func checkGameOver() {
        if player1Life <= 0 {
            player1Life = 0
            updateLifeLabels()

            showGameOverMessage(player: "Player 1")
            disableAllButtons()
        } else if player2Life <= 0 {
            player2Life = 0
            updateLifeLabels()

            showGameOverMessage(player: "Player 2")
            disableAllButtons()
        }
    }
    
    
    private func disableAllButtons() {
      [ player1PlusButton, player1MinusButton, player1Plus5Button, player1Minus5Button,
        player2PlusButton, player2MinusButton, player2Plus5Button, player2Minus5Button ]
        .forEach { $0?.isEnabled = false }
    }
    
    
    func showGameOverMessage(player: String) {
        message.text = "\(player) LOSES!"
        message.textAlignment = .center
        message.isHidden = false
    }


    // MARK: - Player 1 Actions
    @IBAction func player1PlusTapped(_ sender: UIButton) {
        player1Life += 1
        updateLifeLabels()
        checkGameOver()
    }
    
    @IBAction func player1MinusTapped(_ sender: UIButton) {
        player1Life -= 1
        updateLifeLabels()
        checkGameOver()
    }
    
    @IBAction func player1Plus5Tapped(_ sender: UIButton) {
        player1Life += 5
        updateLifeLabels()
        checkGameOver()
    }
    
    @IBAction func player1Minus5Tapped(_ sender: UIButton) {
        player1Life -= 5
        updateLifeLabels()
        checkGameOver()
    }
    
    // MARK: - Player 2 Actions
    @IBAction func player2PlusTapped(_ sender: UIButton) {
        player2Life += 1
        updateLifeLabels()
        checkGameOver()
    }
    
    @IBAction func player2MinusTapped(_ sender: UIButton) {
        player2Life -= 1
        updateLifeLabels()
        checkGameOver()
    }
    
    @IBAction func player2Plus5Tapped(_ sender: UIButton) {
        player2Life += 5
        updateLifeLabels()
        checkGameOver()
    }
    
    @IBAction func player2Minus5Tapped(_ sender: UIButton) {
        player2Life -= 5
        updateLifeLabels()
        checkGameOver()
    }
}

