//
//  TopMenuViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/04.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

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