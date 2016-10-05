import Foundation

class OAuthSwift {
  
  let dataEncoding: NSStringEncoding = NSUTF8StringEncoding
  
  /* GET */
  internal func get (url: String , params: Dictionary<String, String>) -> Bool {
    var urlWithParams = url
    var queryStrings = [String]()
    for (k , v) in params {
      let encodedValue = urlEncode(v)
      queryStrings.append("\(k)=\(encodedValue)")
    }
    if queryStrings.count > 0 {
      urlWithParams += "?" + queryStrings.joinWithSeparator("&")
    }
    return sendOAuthRequest("GET", url: urlWithParams, sendParams: params)
  }
  
  /* POST */
  internal func post (url: String , params: Dictionary<String, String>) -> Bool {
    return sendOAuthRequest("POST", url: url, sendParams: params)
  }
  
  /* OAuthパラメータを生成し、リクエストを送信する */
  private func sendOAuthRequest(method: String , url: String , sendParams: Dictionary<String , String>) -> Bool {
    
    // リクエスト準備
    let requestURL = NSURL(string: url)!
    let originURL = NSURL(string: url.componentsSeparatedByString("?")[0])!
    let request : NSMutableURLRequest = NSMutableURLRequest(URL: requestURL);
    request.HTTPMethod = method
    request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
    
    if (method == "POST") {
      let p = urlEncodedQueryStringWithEncoding(sendParams)
      request.HTTPBody = p.dataUsingEncoding(dataEncoding)
    }
    
    // リクエストパラメータ準備
    var oauthParams = Dictionary<String, String>()
    let oauthKeys = loadOAuthKeys()
    oauthParams["oauth_version"] = "1.0"
    oauthParams["oauth_signature_method"] = "HMAC-SHA1"
    oauthParams["oauth_consumer_key"] = oauthKeys["key"]!
    oauthParams["oauth_timestamp"] = String(Int64(NSDate().timeIntervalSince1970))
    oauthParams["oauth_nonce"] = (NSUUID().UUIDString as NSString).substringToIndex(8)
    oauthParams["oauth_token"] = oauthKeys["access_token"]!
    oauthParams["oauth_signature"] = oauthSignatureForMethod(method , url: originURL, oauthParams: oauthParams, sendParams: sendParams)
    
    // リクエストパラメータをアルファベット順に並べ替える
    var authorizationParameterComponents = urlEncodedQueryStringWithEncoding(oauthParams).componentsSeparatedByString("&") as [String]
    authorizationParameterComponents.sortInPlace { $0 < $1 }
    
    // リクエストパラメータを元に、リクエスト文字列作成
    var headerComponents = [String]()
    for component in authorizationParameterComponents {
      let subcomponent = component.componentsSeparatedByString("=") as [String]
      if subcomponent.count == 2 {
        headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
      }
    }
    
    // リクエストヘッダにリクエスト文字列を付与
    request.setValue("OAuth " + headerComponents.joinWithSeparator(","), forHTTPHeaderField: "Authorization")
    
    // リクエストを送信(強制的に同期処理にする)
    let session = NSURLSession.sharedSession()
    var result: Bool = false
    let semaphore = dispatch_semaphore_create(0)
    let task = session.dataTaskWithRequest(request) { data , response , error in
      if data != nil && response != nil {
        let body = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        print(body)
        result = true
      } else {
        print(error)
      }
      dispatch_semaphore_signal(semaphore)
    }
    task.resume()
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    print(result)
    return result
  }
  
  /* signature作成 */
  private func oauthSignatureForMethod(method: String, url: NSURL, oauthParams: Dictionary<String, String> , sendParams: Dictionary<String, String>) -> String {
    
    let oauthKeys = loadOAuthKeys()
    let signingKey : String = "\(oauthKeys["secret"]!)&\(oauthKeys["access_token_secret"]!)"
    
    var params = oauthParams
    for (key , value) in sendParams {
      params[key] = value
    }
    
    // パラメータ取得してソート
    var parameterComponents = urlEncodedQueryStringWithEncoding(params).componentsSeparatedByString("&") as [String]
    parameterComponents.sortInPlace { $0 < $1 }
    
    // query string作成
    let parameterString = parameterComponents.joinWithSeparator("&")
    
    // urlエンコード
    let encodedParameterString = urlEncode(parameterString)
    let encodedURL = urlEncode(url.absoluteString)
    
    // signature用ベース文字列作成
    let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
    
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
  private func urlEncodedQueryStringWithEncoding(params:Dictionary<String, String>) -> String {
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
  private func urlEncode(str: String) -> String {
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