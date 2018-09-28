//
//  idrNetwork.swift
//  asdk
//
//  Created by ky on 2018/9/26.
//  Copyright © 2018 yellfun. All rights reserved.
//

import Foundation

class idrNetwork {
  
  func request(url:String, data:Dictionary<String, Any>) -> IdrPromise? {
    
    guard !url.isEmpty else {
      
      return nil
    }
    
    return IdrPromise() { resolve, reject in
      
      URLSession.shared.dataTask(with: URL(fileURLWithPath: url)) {(data, _, error) -> Void in
        
        if error != nil {
          
          reject(error!)
          
          return
        }
        
        resolve(data)
      }
    }
  }
}
