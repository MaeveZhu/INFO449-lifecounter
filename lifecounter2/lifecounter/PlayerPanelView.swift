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

  var onLifeChanged: ((Int, Int) -> Void)?
  var onNameTapped: (() -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()

    customAmountTextField.keyboardType = .numberPad
    customAmountTextField.text = "1"
    
    customAmountStepper.minimumValue = -1
    customAmountStepper.maximumValue = 1
    customAmountStepper.stepValue = 1
    customAmountStepper.value = 0
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped))
    nameLabel.isUserInteractionEnabled = true
    nameLabel.addGestureRecognizer(tapGesture)
  }
  
  @objc private func nameLabelTapped() {
    onNameTapped?()
  }

  @IBAction private func didTapPlus(_ sender: UIButton) {
    let customAmount = Int(customAmountTextField.text ?? "1") ?? 1
    let oldLife = life
    life += customAmount
    onLifeChanged?(life, oldLife)
  }

  @IBAction private func didTapMinus(_ sender: UIButton) {
    if life > 0 {
      let customAmount = Int(customAmountTextField.text ?? "1") ?? 1
      let oldLife = life
      life = max(0, life - customAmount)
      onLifeChanged?(life, oldLife)
    }
  }

  @IBAction private func customAmountStepperChanged(_ sender: UIStepper) {
    let customAmount = Int(customAmountTextField.text ?? "1") ?? 1
    let oldLife = life
    
    if sender.value > 0 {
      life += customAmount
    } else if sender.value < 0 && life > 0 {
      life = max(0, life - customAmount)
    }
    
    sender.value = 0
    onLifeChanged?(life, oldLife)
  }

  @IBAction private func customAmountFieldEditingDidEnd(_ sender: UITextField) {
    if let text = sender.text, let value = Int(text), value > 0 {
      sender.text = "\(value)"
    } else {
      sender.text = "1"
    }
  }
}
