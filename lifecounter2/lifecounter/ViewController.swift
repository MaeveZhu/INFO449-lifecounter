import UIKit

class ViewController: UIViewController {
  // MARK: – IBOutlets
  @IBOutlet weak var PlayersStackView: UIStackView!
  @IBOutlet weak var addPlayerButton: UIButton!
  @IBOutlet weak var deletePlayerButton: UIButton!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var resetButton: UIButton!
    
  // MARK: – State
  private var panels: [PlayerPanelView] = []
  private var gameStarted = false
  private var historyViewController: HistoryViewController?
  private var historyEntries: [String] = []
  private var gameOver = false

  // MARK: – Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupInitialState()
  }

  private func setupInitialState() {
    messageLabel.isHidden = true
    resetButton.isEnabled = false
    panels.removeAll()
    historyEntries.removeAll()
    PlayersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    // Add initial 4 players
    for _ in 1...4 {
      addPlayer()
    }
    updateButtons()
  }

  // MARK: – Renumber helper
  private func renumberPanels() {
    for (i, panel) in panels.enumerated() {
      if panel.playerName.isEmpty {
        panel.playerName = "Player \(i+1)"
      }
    }
  }

  // MARK: – IBActions
  @IBAction func addPlayerTapped(_ sender: UIButton) {
    guard panels.count < 8, !gameStarted else { return }
    addPlayer()
    updateButtons()
  }

  @IBAction func deletePlayerTapped(_ sender: UIButton) {
    guard panels.count > 2, !gameStarted else { return }
    let last = panels.removeLast()
    PlayersStackView.removeArrangedSubview(last)
    last.removeFromSuperview()
    renumberPanels()
    updateButtons()
  }
    
  @IBAction func resetButtonTapped(_ sender: UIButton) {
    let alert = UIAlertController(
      title: "Reset Game",
      message: "Are you sure you want to reset the game?",
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
      self?.gameStarted = false
      self?.gameOver = false
      self?.setupInitialState()
    })
    
    present(alert, animated: true)
  }
    
  @IBAction func viewHistoryTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "ShowHistory", sender: nil)
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowHistory",
       let historyVC = segue.destination as? HistoryViewController {
      historyViewController = historyVC
      historyVC.historyEntries = historyEntries
    }
  }

  // MARK: – Core panel logic
  private func addPlayer() {
    let nib = UINib(nibName: "PlayerPanelView", bundle: nil)
    guard let panel = nib.instantiate(withOwner: self, options: nil).first as? PlayerPanelView else {
      return
    }

    panel.life = 20
    panel.onLifeChanged = { [weak self] newLife, oldLife in
      guard let self = self else { return }
      if !self.gameStarted {
        self.gameStarted = true
        self.updateButtons()
      }
      
      // Add history event
      let difference = newLife - oldLife
      let event = "\(panel.playerName) \(difference > 0 ? "gained" : "lost") \(abs(difference)) life"
      self.historyEntries.insert(event, at: 0)
      self.historyViewController?.historyEntries = self.historyEntries
      self.historyViewController?.tableView.reloadData()
      
      if oldLife > 0 && newLife <= 0 {
        panel.life = 0
        self.checkGameOver()
      }
    }
    
    panel.onNameTapped = { [weak self] in
      self?.showNameEditDialog(for: panel)
    }

    panels.append(panel)
    PlayersStackView.addArrangedSubview(panel)
    renumberPanels()
  }
  
  private func checkGameOver() {
    let activePlayers = panels.filter { $0.life > 0 }
    
    if activePlayers.count == 1 {
      let winner = activePlayers[0]
      messageLabel.text = "\(winner.playerName) WINS!"
      messageLabel.isHidden = false
      view.bringSubviewToFront(messageLabel)
      
      let winEvent = "\(winner.playerName) WINS!"
      historyEntries.insert(winEvent, at: 0)
      historyViewController?.historyEntries = historyEntries
      historyViewController?.tableView.reloadData()
      
      gameOver = true
      showGameOverAlert()
    } else if activePlayers.isEmpty {
      messageLabel.text = "Game Over - No Winner!"
      messageLabel.isHidden = false
      view.bringSubviewToFront(messageLabel)
      
      let gameOverEvent = "Game Over - No Winner!"
      historyEntries.insert(gameOverEvent, at: 0)
      historyViewController?.historyEntries = historyEntries
      historyViewController?.tableView.reloadData()
      
      gameOver = true
      showGameOverAlert()
    }
  }
  
  private func showGameOverAlert() {
    let alert = UIAlertController(
      title: "Game Over",
      message: messageLabel.text,
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
      self?.gameStarted = false
      self?.setupInitialState()
    })
    
    present(alert, animated: true)
  }
  
  private func showNameEditDialog(for panel: PlayerPanelView) {
    let alert = UIAlertController(
      title: "Edit Player Name",
      message: "Enter a new name for \(panel.playerName)",
      preferredStyle: .alert
    )
    
    alert.addTextField { textField in
      textField.text = panel.playerName
      textField.placeholder = "Player Name"
    }
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
      if let newName = alert.textFields?.first?.text, !newName.isEmpty {
        panel.playerName = newName
        self?.historyEntries.insert("\(panel.playerName) renamed", at: 0)
        self?.historyViewController?.historyEntries = self?.historyEntries ?? []
        self?.historyViewController?.tableView.reloadData()
      }
    })
    
    present(alert, animated: true)
  }

  private func updateButtons() {
    addPlayerButton.isEnabled = panels.count < 8 && !gameStarted
    deletePlayerButton.isEnabled = panels.count > 2 && !gameStarted
    resetButton.isEnabled = gameStarted || gameOver
  }
}

