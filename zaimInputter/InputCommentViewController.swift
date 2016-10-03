import UIKit
import AudioToolbox
class InputCommentViewController: UIViewController , UITextFieldDelegate {
  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  @IBOutlet weak var placeLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var commentTextView: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    placeLabel.text = zaim.place
    genreLabel.text = zaim.genre
    amountLabel.text = "¥" + String(zaim.amount)
    commentTextView.delegate = self
    commentTextView.becomeFirstResponder()
  }
  
  /*改行キー*/
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    onTappedSubmitButton()
    return true
  }
  
  /* 登録 */
  @IBAction func onTappedSubmitButton() {
    zaim.comment = commentTextView.text!
    let result = zaim.createPaymentData(zaim.genre, place: zaim.place, amount: zaim.amount, comment: zaim.comment)
    if result {
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    let delay = 1 * Double(NSEC_PER_SEC)
    let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue(), {
      exit(0)
    })
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}