//
//  AggregateTopViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/04.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit
class AggregateTopViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
  
  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  @IBOutlet weak var tableview: UITableView!
  
  let headers = ["基本情報" , "日別集計" , "月別集計" , "ランキング"]
  var contents: Array<Array<String>> = [
    ["入力数" , "総収入" , "総支出" , "総利益"],
    ["累計"],
    ["累計" , "食費" , "ガス代" , "電気代" , "水道代" , "ポケモンGO" , "デグー関連"],
    ["カテゴリ" , "ジャンル" , "支払先"]
  ]
  
  /* view did load */
  override func viewDidLoad() {
    tableview.delegate = self
    tableview.dataSource = self
    tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    contents[0][0] = "入力数 \(zaim.IntegerToKanji(zaim.totalInputCount()))回"
    contents[0][1] = "総収入 \(zaim.IntegerToKanji(zaim.totalIncome()))円"
    contents[0][2] = "総支出 \(zaim.IntegerToKanji(zaim.totalPayment()))円"
    contents[0][3] = "総利益 \(zaim.IntegerToKanji(zaim.totalProfit()))円"
  }
  
  /* セクション数 */
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return contents.count
  }
  
  /* セクションのタイトル */
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return headers[section]
  }
  
  /* セル数 */
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contents[section].count
  }
  
  /* セルの内容 */
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let section = indexPath.section
    let row = indexPath.row
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    cell.textLabel?.text = contents[section][row]
    return cell
  }
  
  /* セルをタップ */
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let section = indexPath.section
    let row = indexPath.row
    // 日別集計
    if section == 1 && row == 0 {
      zaim.globalParams["titlelabel"] = "累計 日別"
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 累計
    else if section == 2 && row == 0 {
      zaim.globalParams["titlelabel"] = "累計 月別"
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /* セグエ時にパラメータを引き渡す */
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if zaim.globalParams["titlelabel"] == "累計 日別" {
      let vc = segue.destinationViewController as! DiaryAggregateViewController
      vc.data = zaim.diaryAggregate()
    } else if zaim.globalParams["titlelabel"] == "累計 月別" {
      let vc = segue.destinationViewController as! DiaryAggregateViewController
      vc.data = zaim.monthryAggregate([:])
    }
  }

}
