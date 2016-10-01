//
//  InputCommentViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/01.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit
import AudioToolbox
class InputCommentViewController: UIViewController {
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
    commentTextView.becomeFirstResponder()
  }
  
  /* 登録 */
  @IBAction func onTappedSubmitButton() {
    zaim.comment = commentTextView.text!
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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