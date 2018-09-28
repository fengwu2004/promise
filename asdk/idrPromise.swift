//
//  Promise.swift
//  asdk
//
//  Created by ky on 2018/9/26.
//  Copyright © 2018 yellfun. All rights reserved.
//

import Foundation

class IdrPromise {
  
  enum Status {
    case pending, resolved, rejected
  }
  
  typealias Fn = (Any?)->Void
  
  private var value:Any?
  
  private var status:Status = .pending
  
  private var resolveHandler:((Any?)->Void)?
  
  private var rejectHandler:((Any?)->Void)?
  
  private func resolve(_ value:Any?) -> Void {
    
    self.value = value
    
    self.status = .resolved
    
    if resolveHandler != nil {
      
      resolveHandler!(self.value)
    }
  }
  
  private func reject(_ error:Any?) -> Void {
    
    self.value = error
    
    self.status = .rejected
    
    if rejectHandler != nil {
      
      rejectHandler!(self.value)
    }
  }
  
  func then(_ onResolved:((Any?)->Any?)? = nil, _ onRejected:((Any?)->Any?)? = nil) -> IdrPromise {
    
    if status == .resolved {
      
      return IdrPromise() {(resolve, reject) in
       
        let x = onResolved!(self.value)
        
        if let p = x as? IdrPromise {
          
          p.then(resolve, reject)
        }
        else {
          
          resolve(x)
        }
      }
    }
    
    if status == .rejected {
      
      return IdrPromise() {(resolve, reject) in
        
        let x = onRejected!(self.value)
        
        if let p = x as? IdrPromise {
          
          p.then(resolve, reject)
        }
        else {
          
          resolve(x)
        }
      }
    }
    
    return IdrPromise(){ (resolve, reject) in
      
      self.resolveHandler = {(value) in
        
        let x = onResolved!(value)
        
        if let p = x as? IdrPromise {
          
          p.then(resolve, reject)
        }
        else {
          
          resolve(x)
        }
      }
      
      self.rejectHandler = {(value) in
        
        let x = onRejected!(value)
        
        if let p = x as? IdrPromise {
          
          p.then(resolve, reject)
        }
        else {
          
          resolve(x)
        }
      }
    }
  }
  
  init(_ executor:@escaping (_ resolve:@escaping Fn, _ reject:@escaping Fn)->Void) {
    
    executor(self.resolve, self.reject)
  }
}
