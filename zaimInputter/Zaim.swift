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
  
  var place: String = "";
  var amount: Int = 0;
  var comment: String = "";
  var genre: String = "";
  
  init () {
  }
  
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
  
  internal func loadOAuthKeys () -> Dictionary<String,String> {
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
  
}