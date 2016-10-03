import UIKit

class GenreSelecterViewController: UIViewController {
  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func onTappedGenreButton(sender: UIButton) {
    zaim.genre = sender.currentTitle!
    self.performSegueWithIdentifier("amountinputter", sender: self)
  }
  
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
