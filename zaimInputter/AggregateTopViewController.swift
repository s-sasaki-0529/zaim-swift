//
//  AggregateTopViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/04.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit
class AggregateTopViewController: UIViewController , UITableViewDelegate {
  
  let contents = [
    [
      "title": "基本情報" ,
      "rows" : [
        "入力回数" ,
        "総収入" ,
        "総支出" ,
        "総利益"
      ]
    ] ,
    [
      "title": "日別集計" ,
      "rows": [
        "累計"
      ]
    ] ,
    [
      "title": "月別集計" ,
      "rows": [
        "累計" ,
        "食費" ,
        "ガス代" ,
        "電気代" ,
        "水道代" ,
        "ポケモンGO" ,
        "デグー関連"
      ]
    ] ,
    [
      "title": "ランキング" ,
      "rows": [
        "カテゴリ" ,
        "ジャンル" ,
        "支払先"
      ]
    ]
  ]
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
    
  }
}
