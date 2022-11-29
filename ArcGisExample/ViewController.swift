//
//  ViewController.swift
//  ArcGisExample
//
//  Created by Dave Duprey on 05/10/2022.
//

import UIKit
import W3WSwiftApi
import ArcGIS


class ViewController: UIViewController, AGSGeoViewTouchDelegate {

  // MARK: Settings
  
  // set the API key here
  let x:Any = { AGSArcGISRuntimeEnvironment.apiKey = "YouArcGisApiKey" }()
  
  // for offline use, switch to the SDK instread of the API
  // use `let w3w = What3Words(dataPath: "path-to-w3w-data", engineType: .device)`
  let w3w = What3WordsV3(apiKey: "YourWhat3wordsApiKey")
  
  // MARK: Vars
  
  /// the text field
  lazy var searchController = SearchController() 
  
  /// The ArcGIS map view
  lazy var mapView = W3WAGSMapView(frame: view.frame, w3w: w3w)

  
  // MARK: Initialisation
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupMapView()
    setupTextFeild()
    setupDataSources()
    
    // a starting point
    mapView.addMarker(at: "filled.count.soap")
  }
  
  
  // MARK: Map

  
  /// make self the delegate for touches, and handle errors
  func setupMapView() {
    view = mapView
    
    mapView.touchDelegate = self
    
    mapView.onError = { error in
      self.showErrorIfAny(error: error)
    }
  }
  
  
  // MARK: Text Field
  
  
  /// add the search controller to the view and deal with user selections
  func setupTextFeild() {
    navigationItem.searchController = searchController

    // called when user chooses a suggestion
    searchController.onSelected = { item in

      // if the item is a what3words suggestion
      if let suggestion = item as? W3WSuggestion {
        self.mapView.addMarker(at: suggestion)
      }
      
      // if the item is an ArcGIS result
      if let result = item as? AGSGeocodeResult {
        self.mapView.addMarker(at: result, title: result.label)
      }
    }
    
    searchController.onError = { error in
      self.showErrorIfAny(error: error)
    }
  }
  
  
  // MARK: Data
  
  
  /// make a w3w datasource and an ArcGIS one
  func setupDataSources() {
    
    // the what3words data, and reload on completion closure
    let autosuggest = AutosuggestDataSource(w3w) { [weak self] in
      self?.searchController.reload()
    }
    
    // the arcGIS data, and reload on completion closure
    let arcGis = ArcGISDataSource() { [weak self] in
      self?.searchController.reload()
    }
    
    // add the datasources to the tableview
    searchController.add(dataSource: autosuggest)
    searchController.add(dataSource: arcGis)
  }
  

  // MARK: Map touch
  
  
  // called when the user tapps the map
  func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
    mapView.addMarker(at: mapPoint)
  }

    
  
  // MARK: Show an Error
  
  /// display an error using a UIAlertController, error messages conform to CustomStringConvertible
  func showErrorIfAny(error: Error?) {
    if let e = error {
      DispatchQueue.main.async {
        let alert = UIAlertController(title: "Error", message: String(describing: e), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
      }
    }
  }

  
}

