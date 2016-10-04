import UIKit

class ViewController: UIViewController {

  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func onTappedPlaceButton(sender: UIButton) {
    var place = sender.currentTitle!
    if place == "指定なし" {
      place = ""
    }
    zaim.place = place
    self.performSegueWithIdentifier("genreselecter", sender: self)
  }


}

