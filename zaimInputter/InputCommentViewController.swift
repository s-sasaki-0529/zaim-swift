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
    placeLabel.text = zaim.globalParams["inputPlace"]
    genreLabel.text = zaim.globalParams["inputGenre"]
    amountLabel.text = "¥" + zaim.globalParams["inputAmount"]!
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
    let place = zaim.globalParams["inputPlace"]!
    let genre = zaim.globalParams["inputGenre"]!
    let amount = Int(zaim.globalParams["inputAmount"]!)!
    let comment = commentTextView.text!
    zaim.createPaymentData(genre, place: place, amount: amount, comment: comment)
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    zaim.globalParams = [:];
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}