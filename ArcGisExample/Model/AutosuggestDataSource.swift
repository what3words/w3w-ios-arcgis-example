//
//  AutosuggestDataSource.swift
//  ArcGisExample
//
//  Created by Dave Duprey on 05/10/2022.
//

import Foundation
import W3WSwiftApi


class AutosuggestDataSource: DataSource {
  
  var autosuggest: W3WAutosuggestHelper!
  var w3w: W3WProtocolV3!
  
  init(_ w3w: W3WProtocolV3, updated: @escaping () -> ()) {
    super.init(updated: updated)
    autosuggest = W3WAutosuggestHelper(w3w)
    self.w3w = w3w
  }
  
  
  // when new text comes in we call autosuggest
  override func update(text: String) {
    
    if w3w.isPossible3wa(text: text) {
      autosuggest.update(text: text) { error in
        if let e = error { self.onError(e) }
        
        // clear the data
        self.content = []
        
        // make new data
        for suggestion in self.autosuggest.suggestions {
          self.content.append(Content(title: suggestion.words ?? "---.---.---", detail: suggestion.nearestPlace ?? "", item: suggestion))
        }
        
        // tell the owner of this object there is new data
        self.updated()
      }

    // text wasn't a three word address, clear data
    } else {
      self.content = []
      self.updated()
    }
  }

  
}
