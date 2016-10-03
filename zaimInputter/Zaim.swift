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
  let dataEncoding: NSStringEncoding = NSUTF8StringEncoding
  
  var place: String = "";
  var amount: Int = 0;
  var comment: String = "";
  var genre: String = "";
  
  /* インスタンス生成時に、OAuth認証を行う */
  init () {
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
  
  /* signature作成 */
  func oauthSignatureForMethod(method: String, url: NSURL, parameters: Dictionary<String, String>) -> String {
    let oauthKeys = loadOAuthKeys()
    let signingKey : String = "\(oauthKeys["secret"])&\(oauthKeys["access_token_secret"])"
    let signingKeyData = signingKey.dataUsingEncoding(dataEncoding)
    
    // パラメータ取得してソート
    var parameterComponents = urlEncodedQueryStringWithEncoding(parameters).componentsSeparatedByString("&") as [String]
    parameterComponents.sortInPlace { $0 < $1 }
    
    // query string作成
    let parameterString = parameterComponents.joinWithSeparator("&")
    
    // urlエンコード
    let encodedParameterString = urlEncode(parameterString)
    
    let encodedURL = urlEncode(url.absoluteString)
    
    // signature用ベース文字列作成
    let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
    let signatureBaseStringData = signatureBaseString.dataUsingEncoding(dataEncoding)
    
    // signature作成
    return SHA1DigestWithKey(signatureBaseString, key: signingKey).base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
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
  
  /* Dictionary内のデータをエンコード */
  func urlEncodedQueryStringWithEncoding(params:Dictionary<String, String>) -> String {
    var parts = [String]()
    
    for (key, value) in params {
      let keyString = urlEncode(key)
      let valueString = urlEncode(value)
      let query = "\(keyString)=\(valueString)" as String
      parts.append(query)
    }
    
    return parts.joinWithSeparator("&") as String
  }
  
  /* URLエンコードを行う */
  func urlEncode(str: String) -> String {
    let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFStringRef
    let charactersToLeaveUnescaped = "[]." as CFStringRef
    
    let raw: NSString = str
    
    let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw, charactersToLeaveUnescaped, charactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(dataEncoding)) as NSString
    
    return result as String
  }
  
  /* SHA1署名のハッシュ値を作成 */
  private func SHA1DigestWithKey(base: String, key: String) -> NSData {
    let str = base.cStringUsingEncoding(dataEncoding)
    let strLen = Int(base.lengthOfBytesUsingEncoding(dataEncoding))
    let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
    let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
    let keyLen = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyStr!, keyLen, str!, strLen, result)
    
    return NSData(bytes: result, length: digestLen)
  }
  
  
}