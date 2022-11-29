//
//  W3WArcGISMap.swift
//  ArcGisExample
//
//  Created by Dave Duprey on 07/10/2022.
//

import Foundation
import W3WSwiftApi
import ArcGIS



class W3WAGSMapView: AGSMapView, AGSGeoViewTouchDelegate {

  var onError: (W3WError) -> () = { _ in }
  
  // SDK or API
  let w3w: W3WProtocolV3!

  // the overlay for pins
  var graphicsOverlay = AGSGraphicsOverlay()
  
  // langauge
  var language = "en"
  
  
  init(frame: CGRect, w3w: W3WProtocolV3) {
    self.w3w = w3w

    super.init(frame: frame)
        
    // make the ArcGIS map view the view for this view controller with ESRI topographic basemap.
    map = AGSMap(basemapStyle: .arcGISTopographic)

    // make self the delegate
    touchDelegate = self
    
    // Add the graphics overlay.
    graphicsOverlays.add(self.graphicsOverlay)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: Markers
  
  
  // Zoom to a specific coordinate.
  func addMarker(at suggestion: W3WSuggestion) {
    if let words = suggestion.words {
      self.addMarker(at: words)
    }
  }
  
  
  // Zoom to a specific coordinate.
  func addMarker(at words: String) {
    w3w.convertToCoordinates(words: words) { square, error in
      if let e = error { self.onError(e) }      
      self.addMarker(at: square)
    }
  }
  
  
  // Zoom to a specific coordinate.
  func addMarker(at square: W3WSquare?) {
    if let c = square?.coordinates {
      self.addMarker(at: c, title: square?.words, detail: square?.nearestPlace)
    }
  }
  
  
  // Zoom to a specific coordinate.
  func addMarker(at coordinates: CLLocationCoordinate2D, title: String? = nil, detail: String? = nil) {
    addMarker(at: AGSPoint(x: coordinates.longitude, y: coordinates.latitude, spatialReference: .wgs84()), title: title, detail: detail)
  }
  
  
  // Zoom to a specific coordinate.
  func addMarker(at result: AGSGeocodeResult, title: String? = nil, detail: String? = nil) {
    clearAllMarkers()
    
    if let location = result.displayLocation {
      addMarker(at: location, title: title, detail: detail, attributes: result.attributes!)
    }
  }
  
  
  // Zoom to a specific coordinate.
  func addMarker(at point: AGSPoint, title: String? = nil, detail: String? = nil, attributes: [AnyHashable : Any] = [:]) {
    if let t = title, let d = detail {
      self.placeMarker(point: point, title: t, detail: d)
      
    } else {
      self.w3w.convertTo3wa(coordinates: point.toCLLocationCoordinate2D(), language: self.language) { square, error in
        if let e = error { self.onError(e) }
        
        if let coordinates = square?.coordinates, let title = title ?? square?.words, let detail = detail ?? square?.nearestPlace {
          self.placeMarker(point: AGSPoint(x: coordinates.longitude, y: coordinates.latitude, spatialReference: .wgs84()), title: title, detail: detail)
        }
      }
    }
  }
  
  
  func clearAllMarkers() {
    graphicsOverlay.graphics.removeAllObjects()
  }
  

  
  func placeMarker(point: AGSPoint, title: String, detail: String, attributes: [AnyHashable : Any] = [:]) {
    DispatchQueue.main.async {
      let viewpoint = AGSViewpoint(center: point, scale: 5e4)
      self.setViewpoint(viewpoint, duration: 0.3)
      
      let markerImage = UIImage(systemName: "mappin")!
      let symbol = AGSPictureMarkerSymbol(image: markerImage)
      
      symbol.leaderOffsetY = markerImage.size.height / 2
      symbol.offsetY = markerImage.size.height / 2
      
      let graphic = AGSGraphic(geometry: point, symbol: symbol, attributes: [String: AnyObject]())
      self.graphicsOverlay.graphics.add(graphic)
      
      graphic.attributes.addEntries(from: attributes)
      
      self.callout.title = title
      self.callout.detail = detail
      self.callout.isAccessoryButtonHidden = true
      self.callout.show(for: graphic, tapLocation: point, animated: true)
    }
  }
  
}
