//
//  DiaryAggregateViewController.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/05.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import UIKit
class DiaryAggregateViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
  
  @IBOutlet weak var tableview: UITableView!
  
  /* view did load */
  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.delegate = self
    tableview.dataSource = self
    tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  /* セル数 */
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  /* セルの内容 */
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let section = indexPath.section
    let row = indexPath.row
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    cell.textLabel?.text = "hogehoge"
    return cell
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}