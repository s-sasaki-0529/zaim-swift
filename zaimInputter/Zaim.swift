import Foundation
import OAuthSwift


class Zaim {

  let API_URL = "https://api.zaim.net/v2/";
  let oauth: OAuthSwift = OAuthSwift()
  var place: String = "";
  var amount: Int = 0;
  var comment: String = "";
  var genre: String = "";
  
  /* インスタンス生成時に、OAuth認証を行う */
  init () {
  }
  
  /* 収入データを登録 */
  internal func createIncomeData(category_id: String , date: String , amount: Int , comment: String) {
    let url = "home/money/income"
    var params = Dictionary<String , String>()
    params["category_id"] = category_id
    params["date"] = date
    params["amount"] = String(amount)
    params["comment"] = comment
    post(url , params: params)
  }
  
  /* POST */
  private func post (url: String , params: Dictionary<String, String>) {
    oauth.sendOAuthRequest("POST", url: API_URL + url, postParameters: params)
  }
  
  /* ジャンル名をgenreIDに変換する */
  private func genreToID () -> String {
    let genreToID = [
      "食料品": "10101" ,
      "朝ご飯": "10103" ,
      "昼ご飯": "10104" ,
      "晩ご飯": "10105" ,
      "消耗品": "10201"
    ]
    return genreToID[self.genre]!
  }
  
}