//
//  DataSource.swift
//  ArcGisExample
//
//  Created by Dave Duprey on 05/10/2022.
//

import Foundation
import SwiftUI
import W3WSwiftApi


struct Content {
  var title: String
  var detail: String
  var item: Any
}


class DataSource {
  
  var content = [Content]()
  
  var updated: () -> () = { }
  
  var count: Int {
    get {
      return content.count
    }
  }
  
  var onError: (W3WError) -> () = { _ in }
  
  
  init(updated: @escaping () -> ()) {
    self.updated = updated
  }
  
  
  subscript(index: Int) -> Content {
    return content[index]
  }
  
  func update(text: String) {
  }
  
}
