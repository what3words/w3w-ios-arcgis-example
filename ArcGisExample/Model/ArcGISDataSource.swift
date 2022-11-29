//
//  ArcGISDataSource.swift
//  ArcGisExample
//
//  Created by Dave Duprey on 05/10/2022.
//

import Foundation
import ArcGIS
import W3WSwiftApi


class ArcGISDataSource: DataSource {
  
  /// ArcGIS locator
  let locatorTask = AGSLocatorTask(url: URL(string: "https://geocode-api.arcgis.com/arcgis/rest/services/World/GeocodeServer")!)
  
  /// Used to cancel current ArcGIS request if needed
  var cancelable: AGSCancelable!
  
  /// ensure calls happen no less than 300ms after each other
  lazy var debouncer = W3WTextDebouncer(delay: 0.3) { text in
    self.callArcGis(text: text)
  }
  

  /// called when there is new text, debounces calls to throttle the API call rate
  override func update(text: String) {
    debouncer.call(text: text)
  }
  
  
  /// call ArcGIS API
  func callArcGis(text: String) {
    cancelable?.cancel()
    
    let parameters: AGSGeocodeParameters = {
      let parameters = AGSGeocodeParameters()
      parameters.resultAttributeNames = ["*"]
      parameters.outputSpatialReference = .wgs84()
      return parameters
    }()
    
    // the call to the API
    cancelable = self.locatorTask.geocode(withSearchText: text, parameters: parameters) { [weak self] (results, error) in
      if let e = error {
        self?.onError(W3WError.apiError(e.localizedDescription))
        
      // if results were found
      } else {
        // clear the data
        self?.content = []
        
        // make new data
        for result in results ?? [] {
          self?.content.append(Content(title: result.label, detail: "", item: result))
        }
        
        // inform this object's owner that there is new data available
        self?.updated()
      }
    }
  }
  
  
  
}
