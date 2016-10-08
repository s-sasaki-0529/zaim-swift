import UIKit
class Util {
  
  /* 金額を"万"を含んだ文字列に変換する */
  static internal func IntegerToKanji (num: Int) -> String {
    if num < 10000 {
      return String(num)
    } else {
      let m = num / 10000
      let s = num % 10000
      return "\(m)万\(s)"
    }
  }

}