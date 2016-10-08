import UIKit
class DiaryAggregateViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
  
  private let zaim: Zaim = (UIApplication.sharedApplication().delegate as! AppDelegate).zaim
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var titlelabel: UILabel!
  internal var data: [Dictionary<String , Int>] = []
  
  /* view did load */
  override func viewDidLoad() {
    super.viewDidLoad()
    titlelabel.text = zaim.globalParams["titlelabel"]!
    tableview.delegate = self
    tableview.dataSource = self
    tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  /* セル数 */
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.data.count
  }
  
  /* セルの内容 */
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let row = indexPath.row
    var key = self.data[row].first!.0
    let value = self.data[row].first!.1
    if zaim.globalParams["titlelabel"] == "ランキング ジャンル" {
      key = zaim.genreIDToGenreName(key)
    } else if zaim.globalParams["titlelabel"] == "ランキング カテゴリ" {
      key = zaim.categoryIDToCategoryName(key)
    }
    
    let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
    cell.textLabel?.text = key
    cell.detailTextLabel!.text = Util.IntegerToKanji(value) + zaim.globalParams["aggsuffix"]!
    return cell
  }
  
  /* セルをタップ */
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = indexPath.row
    let cell = data[row].first!.0
    var url: String = ""
    if cell == "合計" { return }
    switch zaim.globalParams["titlelabel"]! {
    case "日別集計 累計" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)&end_date=\(cell)"
      break
    case "月別集計 累計" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)-01&end_date=\(monthToLastDay(cell))"
      break
    case "月別集計 食費" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)-01&end_date=\(monthToLastDay(cell))&payment_category_id=101"
      break
    case "月別集計 ガス代" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)-01&end_date=\(monthToLastDay(cell))&genre_id=10503"
      break
    case "月別集計 電気代" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)-01&end_date=\(monthToLastDay(cell))&genre_id=10502"
      break
    case "月別集計 水道代" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)-01&end_date=\(monthToLastDay(cell))&genre_id=10501"
      break
    case "月別集計 ポケモンGO" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)-01&end_date=\(monthToLastDay(cell))&comment=ポケモンGO"
      break
    case "月別集計 デグー関連" :
      url = "https://zaim.net/money?mode=payment&start_date=\(cell)-01&end_date=\(monthToLastDay(cell))&genre_id=10203"
      break
    case "ランキング カテゴリ" :
      url = "https://zaim.net/money?mode=payment&payment_category_id=\(cell)"
      break
    case "ランキング ジャンル" :
      url = "https://zaim.net/money?mode=payment&genre_id=\(cell)"
      break
    case "ランキング 支払先" :
      url = "https://zaim.net/money?mode=payment&place=\(cell)"
      break
    default :
      break
    }
    url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /* 2016-05 → 2016-05-31 */
  private func monthToLastDay(month: String) -> String {
    let ms = (month as NSString).substringFromIndex(5)
    let mi = Int(ms)! - 1
    let days = [31 , 28 , 31 , 30 , 31 , 30 , 31 , 31 , 30 , 31 , 30 , 31]
    return "\(month)-\(days[mi])"
  }
}