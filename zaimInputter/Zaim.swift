import Foundation


class Zaim {
  
  static var zaimObject: Zaim? = nil
  
  let API_URL = "https://api.zaim.net/v2/";
  let oauth: OAuthSwift = OAuthSwift()
  var allMoney: [Dictionary<String , String>]? = nil
  var globalParams: Dictionary<String , String> = Dictionary()
  
  /* 原則シングルトンとする */
  private init () {}
  static internal func getInstance () -> Zaim {
    if Zaim.zaimObject == nil {
      Zaim.zaimObject = Zaim()
    }
    return Zaim.zaimObject!
  }
  
  /* 支出データを登録 */
  internal func createPaymentData(genreName: String , place: String , amount: Int , comment: String) {
    let url = API_URL + "home/money/payment"
    var params = Dictionary<String , String>()
    params["category_id"] = genreToCategoryID(genreName)
    params["genre_id"] = genreToID(genreName)
    params["place"] = place
    params["amount"] = String(amount)
    params["comment"] = comment
    oauth.post(url , params:params)
  }
  
  /* 収入データを登録 */
  internal func createIncomeData(category_id: String , date: String , amount: Int , comment: String) {
    let url = API_URL + "home/money/income"
    var params = Dictionary<String , String>()
    params["category_id"] = category_id
    params["date"] = date
    params["amount"] = String(amount)
    params["comment"] = comment
    oauth.post(url , params: params)
  }
  
  /* 総入力回数を取得 */
  internal func totalInputCount () -> Int {
    return getAllMoney().count
  }
  
  /* 総支出額を取得 */
  internal func totalPayment () -> Int {
    return getAllPayment().reduce(0) { (sum , p) -> Int in sum + Int(p["amount"]!)! }
  }
  
  /* 総収入額を取得 */
  internal func totalIncome () -> Int {
    return getAllIncome().reduce(0) { (sum , p) -> Int in sum + Int(p["amount"]!)! }
  }
  
  /* 総利益を取得 */
  internal func totalProfit () -> Int {
    // 収入が支出を上回っている前提
    return totalIncome() - totalPayment()
  }
  
  /* 日別集計を取得 */
  internal func diaryAggregate () -> [Dictionary<String , Int>] {
    return aggregate([:])
  }
  
  /* 月別集計を取得 */
  internal func monthryAggregate (params: Dictionary<String , String>) -> [Dictionary<String , Int>] {
    var newParams = params
    newParams["term"] = "monthly"
    return aggregate(newParams)
  }
  
  /* 支出を特定の条件でランキング化 */
  internal func createRanking(params: Dictionary<String , String>) -> [Dictionary<String , Int>] {
    var aggDic = Dictionary<String , Int>()
    var aggArray = [Dictionary<String , Int>]()
    
    // 集計対象の要素ごとにその個数をカウント
    for pay in getAllPayment() {
      let key = pay[params["target"]!]!
      if aggDic[key] == nil {
        aggDic[key] = 0
      }
      aggDic[key]! += 1
    }
    
    // 支払先別の場合、未入力データは削除
    if params["target"] == "place" {
      aggDic.removeValueForKey("")
    }
    
    // 配列に変換し、ソート
    for (k , v) in aggDic { aggArray.append([k:v]) }
    aggArray = aggArray.sort({ (a , b) in b.first!.1 < a.first!.1 })
    
    return aggArray
  }
  
  /* 支出を特定の条件で集計する */
  private func aggregate(params: Dictionary<String , String>) -> [Dictionary<String , Int>] {
    var da = Dictionary<String , Int>()
    var paymentsArray: [String] = []
    var result: [Dictionary<String ,Int>] = []
    var payments: [Dictionary<String,String>] = []
    let paymentsOrigin = getAllPayment()
    
    // 集計対象の期間
    if params["term"] == "monthly" {
      for var pay in paymentsOrigin {
        pay["date"] = (pay["date"]! as NSString).substringWithRange(NSRange(location: 0,length: 7))
        payments.append(pay)
      }
    } else {
      payments = paymentsOrigin
    }
    
    // 集計対象の絞込
    if params["category_id"] != nil {
      payments = payments.filter({ (pay) -> Bool in pay["category_id"] == params["category_id"]})
    } else if params["genre_id"] != nil {
      payments = payments.filter({ (pay) -> Bool in pay["genre_id"] == params["genre_id"]})
    } else if params["comment"] != nil {
      payments = payments.filter({ (pay) -> Bool in pay["comment"] == params["comment"]})
    }
    
    // 期間ごとに集計
    for pay in payments {
      let date = pay["date"]!
      let amount = Int(pay["amount"]!)!
      if da[date] == nil {
        paymentsArray.append(date)
        da[date] = amount
      } else {
        da[date] = da[date]! + amount
      }
    }
    
    for day in paymentsArray {
      result.append([day:da[day]!])
    }
    return result
  }
  
  /* 全支出情報を取得 */
  private func getAllPayment () -> [Dictionary<String , String>] {
    return grepMoneyInfo(["mode": "payment"])
  }
  
  /* 全収入情報を取得 */
  private func getAllIncome () -> [Dictionary<String , String>] {
    return grepMoneyInfo(["mode": "income"])
  }
  
  /* 全支出情報から特定の支出を抜き出す */
  private func grepMoneyInfo (params: Dictionary<String , String>) -> [Dictionary<String ,String>] {
    let allMoney = getAllMoney()
    let grepedMoney = allMoney.filter { (m) -> Bool in
      var result = true
      for (k , v) in params {
        if m[k] != v {
          result = false
          break
        }
      }
      return result
    }
    return grepedMoney
  }
  
  /* 全入力情報取得し、キャッシュする */
  private func getAllMoney () -> [Dictionary<String , String>] {
    //なんかもうメチャクチャなので、JSONの変換から見直したい
    if self.allMoney == nil {
      let nsdicMoneys = oauth.get(API_URL + "home/money" , params: [:])["money"]! as! [NSDictionary]
      var dicMoneys = [Dictionary<String , String>]()
      for m in nsdicMoneys {
        var param = Dictionary<String , String>()
        for (k , v) in m {
          param[k as! String] = String(v)
        }
        dicMoneys.append(param)
      }
      self.allMoney = dicMoneys
    }
    return self.allMoney!
  }
  
  /* ジャンル名をgenreIDに変換する(入力用 静的データ) */
  private func genreToID (genreName: String) -> String {
    let genreIdMap = [
      "食料品": "10101" ,
      "朝ご飯": "10103" ,
      "昼ご飯": "10104" ,
      "晩ご飯": "10105" ,
      "消耗品": "10201" ,
      "電車": "10301" ,
      "バス": "10303"
    ]
    return genreIdMap[genreName]!
  }
  
  /* ジャンル名を親カテゴリのcategoryIDに変換する(入力用 静的データ) */
  private func genreToCategoryID(genreName: String) -> String {
    let genreIdMap = [
      "食料品": "101" ,
      "朝ご飯": "101" ,
      "昼ご飯": "101" ,
      "晩ご飯": "101" ,
      "消耗品": "102" ,
      "電車": "103" ,
      "バス": "103"
    ]
    return genreIdMap[genreName]!
  }
  
}