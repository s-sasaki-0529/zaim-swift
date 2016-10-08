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
    let date = self.data[row].first!.0
    let amount = self.data[row].first!.1
    let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
    cell.textLabel?.text = date
    cell.detailTextLabel!.text = Util.IntegerToKanji(amount) + zaim.globalParams["aggsuffix"]!
    return cell
  }
  
  /* セルをタップ */
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = indexPath.row
    let date = data[row].first!.0
    let url = NSURL(string: "https://zaim.net/money?start_date=" + date + "&end_date=" + date)
    UIApplication.sharedApplication().openURL(url!)
  }
  
  /* 戻る */
  @IBAction func onTappedBackButton() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}