import UIKit
class TopMenuViewController: UIViewController {
  
  /* 入力する */
  @IBAction func onTappedInputButton() {
    self.performSegueWithIdentifier("inputplace", sender: self)
  }
  
  /* 集計を見る */
  @IBAction func onTappedAggregateButton() {
    self.performSegueWithIdentifier("aggregatetop", sender: self)
  }
  
  
}