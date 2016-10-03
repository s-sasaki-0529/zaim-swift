import UIKit

class ViewController: UIViewController {

  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func onTappedPlaceButton(sender: UIButton) {
    zaim.place = sender.currentTitle!
    self.performSegueWithIdentifier("genreselecter", sender: self)
  }


}

