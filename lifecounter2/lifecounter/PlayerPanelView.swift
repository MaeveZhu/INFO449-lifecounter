import UIKit

class PlayerPanelView: UIView {
  
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var lifeLabel: UILabel!
  @IBOutlet private weak var plusButton: UIButton!
  @IBOutlet private weak var minusButton: UIButton!
  @IBOutlet private weak var customAmountTextField: UITextField!
  @IBOutlet private weak var customAmountStepper: UIStepper!

  var playerName: String = "" {
    didSet { nameLabel.text = playerName }
  }

  var life: Int = 20 {
    didSet {
      lifeLabel.text = "\(life)"
      minusButton.isEnabled = life > 0
    }
  }

  var onLifeChanged: ((Int) -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()

    customAmountTextField.keyboardType = .numberPad
    customAmountTextField.text = "1"
    
    customAmountStepper.minimumValue = -1
    customAmountStepper.maximumValue = 1
    customAmountStepper.stepValue = 1
    customAmountStepper.value = 0
  }

  @IBAction private func didTapPlus(_ sender: UIButton) {
    life += 1
    onLifeChanged?(life)
  }

  @IBAction private func didTapMinus(_ sender: UIButton) {
    if life > 0 {
      life -= 1
      onLifeChanged?(life)
    }
  }

  @IBAction private func customAmountStepperChanged(_ sender: UIStepper) {
    let customAmount = Int(customAmountTextField.text ?? "1") ?? 1
    
    if sender.value > 0 {
      life += customAmount
    } else if sender.value < 0 && life > 0 {
      life = max(0, life - customAmount)
    }
    
    sender.value = 0
    onLifeChanged?(life)
  }

  @IBAction private func customAmountFieldEditingDidEnd(_ sender: UITextField) {
    let value = Int(sender.text ?? "") ?? 1
    sender.text = "\(value)"
  }
}
