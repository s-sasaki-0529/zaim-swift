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
  
  /* 支出データを登録 */
  internal func createPaymentData(genreName: String , place: String , amount: Int , comment: String) {
    let url = "home/money/payment"
    var params = Dictionary<String , String>()
    params["category_id"] = genreToCategoryID(genreName)
    params["genre_id"] = genreToID(genreName)
    params["place"] = place
    params["amount"] = String(amount)
    params["comment"] = comment
    post(url , params:params)
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
  private func genreToID (genreName: String) -> String {
    let genreIdMap = [
      "食料品": "10101" ,
      "朝ご飯": "10103" ,
      "昼ご飯": "10104" ,
      "晩ご飯": "10105" ,
      "消耗品": "10201"
    ]
    return genreIdMap[genreName]!
  }
  
  /* ジャンル名を親カテゴリのcategoryIDに変換する */
  private func genreToCategoryID(genreName: String) -> String {
    let genreIdMap = [
      "食料品": "101" ,
      "朝ごはん": "101" ,
      "昼ご飯": "101" ,
      "晩ご飯": "101" ,
      "消耗品": "102"
    ]
    return genreIdMap[genreName]!
  }
  
}