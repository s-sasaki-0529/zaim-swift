//
//  AggregateTopViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/04.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit
class AggregateTopViewController: UIViewController , UITableViewDelegate {
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
    
  }
}
