import UIKit
class AggregateTopViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
  
  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  private var aggregate: [Dictionary<String , Int>] = []
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
    contents[0][0] = "入力数 \(Util.IntegerToKanji(zaim.totalInputCount()))回"
    contents[0][1] = "総収入 \(Util.IntegerToKanji(zaim.totalIncome()))円"
    contents[0][2] = "総支出 \(Util.IntegerToKanji(zaim.totalPayment()))円"
    contents[0][3] = "総利益 \(Util.IntegerToKanji(zaim.totalProfit()))円"
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
      self.aggregate = zaim.diaryAggregate()
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 累計
    else if section == 2 && row == 0 {
      zaim.globalParams["titlelabel"] = "累計 月別"
      self.aggregate = zaim.monthryAggregate([:])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 食費
    else if section == 2 && row == 1 {
      zaim.globalParams["titlelabel"] = "食費 月別"
      self.aggregate = zaim.monthryAggregate(["category_id": "101"])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 ガス代
    else if section == 2 && row == 2 {
      zaim.globalParams["titlelabel"] = "ガス代 月別"
      self.aggregate = zaim.monthryAggregate(["genre_id": "10503"])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 電気代
    else if section == 2 && row == 3 {
      zaim.globalParams["titlelabel"] = "電気代 月別"
      self.aggregate = zaim.monthryAggregate(["genre_id": "10502"])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 水道代
    else if section == 2 && row == 4 {
      zaim.globalParams["titlelabel"] = "水道代 月別"
      self.aggregate = zaim.monthryAggregate(["genre_id": "10501"])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 ポケモンGO
    else if section == 2 && row == 5 {
      zaim.globalParams["titlelabel"] = "ポケモンGO 月別"
      self.aggregate = zaim.monthryAggregate(["comment": "ポケモンGO"])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // 月別集計 デグー関連
    else if section == 2 && row == 6 {
      zaim.globalParams["titlelabel"] = "デグー関連 月別"
      self.aggregate = zaim.monthryAggregate(["genre_id": "10203"])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    // ランキング 支払先
    else if section == 3 && row == 2 {
      zaim.globalParams["titlelabel"] = "支払先 ランキング"
      self.aggregate = zaim.createRanking(["target": "place"])
      self.performSegueWithIdentifier("aggregate", sender: self)
    }
    
    // 集計結果の単位
    if section == 3 {
      zaim.globalParams["aggsuffix"] = " 回"
    } else {
      zaim.globalParams["aggsuffix"] = " 円"
    }
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /* セグエ時にパラメータを引き渡す */
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let vc = segue.destinationViewController as! DiaryAggregateViewController
    let sum = self.aggregate.reduce(0) { (sum , p) -> Int in sum + p.first!.1 }
    self.aggregate.append(["合計" : sum])
    vc.data = self.aggregate
  }

}
