//
//  InputCommentViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/01.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit
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
    
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}