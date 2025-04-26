import UIKit

class ViewController: UIViewController {
  // MARK: – IBOutlets
  @IBOutlet weak var PlayersStackView: UIStackView!
  @IBOutlet weak var addPlayerButton: UIButton!
  @IBOutlet weak var deletePlayerButton: UIButton!
  @IBOutlet weak var messageLabel: UILabel!
    
  // MARK: – State
  private var panels: [PlayerPanelView] = []
  private var gameStarted = false

  // MARK: – Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    messageLabel.isHidden = true
    for _ in 1...4 {addPlayer()}
    updateButtons()
  }

  // MARK: – Renumber helper
  private func renumberPanels() {
    for (i, panel) in panels.enumerated() {
      panel.playerName = "Player \(i+1)"
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

  // MARK: – Core panel logic
  private func addPlayer() {
    let nib = UINib(nibName: "PlayerPanelView", bundle: nil)
    guard let panel = nib.instantiate(
            withOwner: self,
            options: nil
          ).first as? PlayerPanelView else {
      return
    }

    panel.life = 20
      panel.onLifeChanged = { [weak self] newLife in
        guard let self = self else { return }
        if !self.gameStarted {
          self.gameStarted = true
          self.updateButtons()
        }
        if newLife <= 0 {
          panel.life = 0
          self.messageLabel.text = "\(panel.playerName) LOSES!"
          self.messageLabel.isHidden = false
          self.view.bringSubviewToFront(self.messageLabel)
        }
      }

    panels.append(panel)
    PlayersStackView.addArrangedSubview(panel)
    renumberPanels()
  }

  private func updateButtons() {
    addPlayerButton.isEnabled    = panels.count < 8 && !gameStarted
    deletePlayerButton.isEnabled = panels.count > 2 && !gameStarted
  }
}

