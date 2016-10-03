import UIKit
class AmountInputterViewController: UIViewController {
  @IBOutlet weak var amountLabel: UILabel!
  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  /* 1〜9 */
  @IBAction func onTappedNumberButton(sender: UIButton) {
    let num: String = sender.currentTitle!
    if amountLabel.text?.characters.count < 7 {
      amountLabel.text! += num
    }
  }
  
  /* 0 */
  @IBAction func onTappedZeroButton(sender: UIButton) {
    if (amountLabel.text != "") {
      onTappedNumberButton(sender)
    }
  }
  
  /* ÷2 */
  @IBAction func onTappedDiv2Button() {
    let amount = toInt()
    setLabel(String(Int(amount / 2)))
  }
  
  /* ×1.08 */
  @IBAction func onTappedTaxButton() {
    let amount = Double(toInt())
    setLabel(String(Int(amount * 1.08)))
  }
  
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /* C */
  @IBAction func onTappedClearButton() {
    setLabel("")
  }
  
  /* ← */
  @IBAction func onTappedDeleteButton() {
    var amount:String = amountLabel.text!
    if amount != "" {
      let idx = amount.endIndex.advancedBy(-1)
      amount = amount.substringToIndex(idx)
      setLabel(amount)
    }
  }
  
  /* GO */
  @IBAction func onTappedGoButton() {
    zaim.amount = toInt()
    self.performSegueWithIdentifier("inputcomment", sender: self);
  }
  
  /*ラベルの内容を更新*/
  private func setLabel(number: String) {
    if number == "0" {
      amountLabel.text = ""
    } else if amountLabel.text?.characters.count > 7 {
      amountLabel.text = ""
    }else {
      amountLabel.text = number
    }
  }
  
  /*ラベルの内容を整数に変換*/
  private func toInt() -> Int {
    if amountLabel.text == "" {
      return 0
    } else {
      return Int(amountLabel.text!)!
    }
  }
}