import Foundation

class OAuthSwift{
  // oauthリクエスト参考
  // http://developer.yahoo.co.jp/other/oauth/signinrequest.html
  // http://www.pressmantech.com/tech/programming/1137
  
  
  var dataEncoding: NSStringEncoding = NSUTF8StringEncoding
  
  var data : NSMutableData? = nil
  
  var consumer_key: String
  var consumer_secret: String
  var request_token_url: String
  var authorize_url: String
  var access_token_url: String
  
  // コンストラクタ
  init(consumerKey: String, consumerSecret: String, requestTokenUrl: String, authorizeUrl: String, accessTokenUrl: String){
    self.consumer_key = consumerKey
    self.consumer_secret = consumerSecret
    self.request_token_url = requestTokenUrl
    self.authorize_url = authorizeUrl
    self.access_token_url = accessTokenUrl
  }
  
  func start() -> Void{
    // クライアントアプリケーションの作成
    // 流れとして request_token投げる -> ouath_token取得(今ここ) -> authrize_request投げる -> access_token取得 -> API使用
    
    // リクエストURL設定
    let twitterURL : NSURL = NSURL(string: "https://api.twitter.com/oauth/request_token")!
    
    // request
    let request : NSMutableURLRequest = NSMutableURLRequest(URL: twitterURL);
    request.HTTPMethod = "POST"
    request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
    
    // oauth_request設定
    var param = Dictionary<String, String>()
    // バージョン
    param["oauth_version"] = "1.0"
    // 証明書アルゴリズム(Twitterでは固定)
    param["oauth_signature_method"] = "HMAC-SHA1"
    // ConsumerKey
    param["oauth_consumer_key"] = self.consumer_key
    // Unixタイムスタンプ
    param["oauth_timestamp"] = String(Int64(NSDate().timeIntervalSince1970))
    // ランダムな文字列
    param["oauth_nonce"] = (NSUUID().UUIDString as NSString).substringToIndex(8)
    // コールバック
    param["oauth_callback"] = "oauth-swift://"
    // 証明書
    param["oauth_signature"] = self.oauthSignatureForMethod("POST", url: twitterURL, parameters: param)
    
    // アルファベット順に並べ替える
    var authorizationParameterComponents = urlEncodedQueryStringWithEncoding(param).componentsSeparatedByString("&") as [String]
    authorizationParameterComponents.sortInPlace { $0 < $1 }
    
    // リクエスト文字列作成
    var headerComponents = [String]()
    for component in authorizationParameterComponents {
      let subcomponent = component.componentsSeparatedByString("=") as [String]
      if subcomponent.count == 2 {
        headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
      }
    }
    
    
    // 最終的にリクエストするのは下記文字列
    // "OAuth oauth_callback=\"swift-oauth%3A%2F%2Fswift-oauth%2F\", oauth_consumer_key=\"CXubzXLR2vzqbCf1d9maSJ4ob\", oauth_nonce=\"46B623F4\", oauth_signature=\"%2Brx8F1ofGHhQe0iN%2Ff7MArz05F4%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1422107013\", oauth_version=\"1.0\""
    
    // リクエスト設定
    request.setValue("OAuth " + headerComponents.joinWithSeparator(", "), forHTTPHeaderField: "Authorization")
    
    // 非同期通信開始
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){
      
      response, data, error in
      
      if(error != nil){
        // エラー文言表示
        print(error!.description)
      }
      // oauth_token表示
      print(NSString(data: data!, encoding: self.dataEncoding)!)
    }
  }
  
  // サーバからレスポンスを受け取ったときのデリゲート
  func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
    // Recieved a new request, clear out the data object
    self.data! = NSMutableData()
  }
  
  // サーバからデータが送られてきたときのデリゲート
  func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
    self.data!.appendData(data)
  }
  
  // データロードが完了したときのデリゲート
  func connectionDidFinishLoading(connection: NSURLConnection!){
    // バイナリデータが発行される
    let html : String = NSString(data: self.data!, encoding: NSUTF8StringEncoding)! as String
    // コンソールに出力
    print(html)
    
  }
  
  // signature作成
  func oauthSignatureForMethod(method: String, url: NSURL, parameters: Dictionary<String, String>) -> String {
    let signingKey : String = "\(self.consumer_secret)&"
    let signingKeyData = signingKey.dataUsingEncoding(dataEncoding)
    
    // パラメータ取得してソート
    var parameterComponents = urlEncodedQueryStringWithEncoding(parameters).componentsSeparatedByString("&") as [String]
    parameterComponents.sortInPlace { $0 < $1 }
    
    // query string作成
    let parameterString = parameterComponents.joinWithSeparator("&")
    
    // urlエンコード
    let encodedParameterString = urlEncodedStringWithEncoding(parameterString)
    
    let encodedURL = urlEncodedStringWithEncoding(url.absoluteString)
    
    // signature用ベース文字列作成
    let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
    let signatureBaseStringData = signatureBaseString.dataUsingEncoding(dataEncoding)
    
    // signature作成
    return SHA1DigestWithKey(signatureBaseString, key: signingKey).base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
  }
  
  // Dictionary内のデータをエンコード
  func urlEncodedQueryStringWithEncoding(params:Dictionary<String, String>) -> String {
    var parts = [String]()
    
    for (key, value) in params {
      let keyString = urlEncodedStringWithEncoding(key)
      let valueString = urlEncodedStringWithEncoding(value)
      let query = "\(keyString)=\(valueString)" as String
      parts.append(query)
    }
    
    return parts.joinWithSeparator("&") as String
  }
  
  // URLエンコード
  func urlEncodedStringWithEncoding(str: String) -> String {
    let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFStringRef
    let charactersToLeaveUnescaped = "[]." as CFStringRef
    
    let raw: NSString = str
    
    let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw, charactersToLeaveUnescaped, charactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(dataEncoding)) as NSString
    
    return result as String
  }
  
  // SHA1署名のハッシュ値を作成
  func SHA1DigestWithKey(base: String, key: String) -> NSData {
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