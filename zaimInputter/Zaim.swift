//
//  Zaim.swift
//  zaimInputter
//
//  Created by 笹木信吾 on 2016/10/01.
//  Copyright © 2016年 笹木信吾. All rights reserved.
//

import Foundation

class Zaim {
  
  var place: String = "";
  var amount: Int = 0;
  var comment: String = "";
  var genre: String = "";
  
  init () {
    
  }
  
  internal func genreToID () -> String {
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