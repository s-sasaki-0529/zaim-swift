//
//  AggregateTopViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/04.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit
class AggregateTopViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
  
  @IBOutlet weak var tableview: UITableView!
  
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
  
  /* view did load */
  override func viewDidLoad() {
    tableview.delegate = self
    tableview.dataSource = self
    tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  /* セクション数 */
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return contents.count
  }
  
  /* セクションのタイトル */
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return contents[section]["title"]! as? String
  }
  
  /* セル数 */
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contents[section]["rows"]!.count
  }
  
  /* セルの内容 */
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let rows: [String] = contents[indexPath.section]["rows"] as! [String]
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
    cell.textLabel?.text = rows[indexPath.row]
    return cell
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
    
  }
}
