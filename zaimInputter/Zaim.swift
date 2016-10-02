//
//  Zaim.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/01.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import Foundation
import OAuthSwift


class Zaim {
  
  let SITE_URL = "https://api.zaim.net";
  let API_URL = "https://api.zaim.net/v2/";
  let REQUEST_TOKEN_PATH = "/v2/auth/request";
  let AUTHORIZE_URL = "https://auth.zaim.net/users/auth";
  let ACCESS_TOKEN_PATH = "https://api.zaim.net";
  
  var place: String = "";
  var amount: Int = 0;
  var comment: String = "";
  var genre: String = "";
  
  /* インスタンス生成時に、OAuth認証を行う
   */
  init () {
    print(generateSignature())
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
  
  /* OAuth認証に必要なHTTPヘッダを生成 */
  private func createHeader () {
    let oauthKeys = loadOAuthKeys()
    var headers = Dictionary<String,String>()
    headers["oauth_consumer_key"] = oauthKeys["key"]
    headers["oauth_token"] = oauthKeys["access_token"]
    headers["auth_signature_method"] = "HMAC-SHA1"
    headers["oauth_signature"] = "hoge"
    headers["oauth_timestamp"] = String(Int(NSDate().timeIntervalSince1970))
    headers["oauth_nonce"] = generateRandomString(32)
    print(headers)
  }
  
  /* OAuth認証用の情報をローカルファイルから取得 */
  private func loadOAuthKeys () -> Dictionary<String,String> {
    let path = NSBundle.mainBundle().pathForResource("keys", ofType: "json")!
    let jsonData = NSData(contentsOfFile: path)!
    do {
      let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! Dictionary<String , String>
      return json
    } catch let err as NSError {
      print(err.localizedDescription)
    }
    return Dictionary<String,String>()
  }
  
  /* OAuthに必要な署名を生成する  */
  private func generateSignature () -> String {
    let oauthKeys = loadOAuthKeys()
    let url = urlEncode("http://example.com/sample.php")
    let method = "POST"
    let param = urlEncode("name=BBB&text=CCC&title=AAA")
    let signatureKey = oauthKeys["secret"]! + "&" + oauthKeys["access_token_secret"]!
    let data = [method , url , param].joinWithSeparator("&")
    let hash = SHA1DigestWithKey(data, key: signatureKey).base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
    return hash
  }
  
  /* ランダムな文字列を生成 */
  func generateRandomString(length: Int) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""
    
    for _ in 0..<length {
      let randomValue = arc4random_uniform(UInt32(base.characters.count))
      randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
    }
    return randomString
  }
  
  /* URLエンコードする */
  func urlEncode(str: String) -> String {
    let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFStringRef
    let charactersToLeaveUnescaped = "[]." as CFStringRef
    
    let raw: NSString = str
    
    let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw, charactersToLeaveUnescaped, charactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as NSString
    
    return result as String
  }
  
  /* SHA1署名のハッシュ値を作成 */
  func SHA1DigestWithKey(base: String, key: String) -> NSData {
    let str = base.cStringUsingEncoding(NSUTF8StringEncoding)
    let strLen = Int(base.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
    let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
    let keyLen = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyStr!, keyLen, str!, strLen, result)
    return NSData(bytes: result, length: digestLen)
  }
  
  
}