import Foundation


class Zaim {
  
  static var zaimObject: Zaim? = nil
  
  let API_URL = "https://api.zaim.net/v2/";
  let oauth: OAuthSwift = OAuthSwift()
  var allMoney: [Dictionary<String , String>]? = nil
  
  var place: String = "";
  var amount: Int = 0;
  var comment: String = "";
  var genre: String = "";
  
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
  
  /* ジャンル名をgenreIDに変換する */
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
  
  /* ジャンル名を親カテゴリのcategoryIDに変換する */
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