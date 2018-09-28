//
//  ViewController.swift
//  asdk
//
//  Created by ky on 2018/9/26.
//  Copyright © 2018 yellfun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let p = IdrPromise() { (resolve, nil) in
      
      DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime(uptimeNanoseconds: NSEC_PER_SEC * 1), execute: {
        
        resolve("hello promise")
      })
    }
    
    p.then({ res in
      
      return IdrPromise() {(resolve, reject) in
     
        resolve("Hello\(res ?? "do some thing")")
      }
    })
    .then({res in
      
      print(res ?? "true")
    })
  }
}
