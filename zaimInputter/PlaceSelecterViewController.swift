import UIKit

class ViewController: UIViewController {

  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  /* placeボタン */
  @IBAction func onTappedPlaceButton(sender: UIButton) {
    var place = sender.currentTitle!
    if place == "指定なし" {
      place = ""
    }
    zaim.globalParams["inputPlace"] = place
    self.performSegueWithIdentifier("genreselecter", sender: self)
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  


}

