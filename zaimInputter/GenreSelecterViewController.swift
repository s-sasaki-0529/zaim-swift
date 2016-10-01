//
//  GenreSelecterViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/01.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit

class GenreSelecterViewController: UIViewController {
  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
}
