//
//  SearchController.swift
//  ArcGisExample
//
//  Created by Dave Duprey on 07/10/2022.
//

import UIKit
import W3WSwiftApi


class SearchController: UISearchController, UISearchResultsUpdating, UISearchControllerDelegate {
    
  var onSelected: (Any) -> () = { _ in }

  var onError: (W3WError) -> () = { _ in }

  
  /// The table to show suggestions
  let tableViewController = TableViewController()

  
  /// initialise the map
  init() {
    super.init(searchResultsController: tableViewController)
    
    searchResultsUpdater = self
    delegate = self
    
    // when an item is selected, make textField inactive and handle the request
    tableViewController.onSelected = { item in
      self.isActive = false
      self.onSelected(item)
    }
    
    tableViewController.onError = { error in
      self.onError(error)
    }

  }
  
  
  /// for another day
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /// adds a data source to use for search suggestions
  func add(dataSource: DataSource) {
    tableViewController.add(dataSource: dataSource)
  }


  /// refresh the suggestion list with any new results
  func reload() {
    tableViewController.reload()
  }
  
  
  /// called when the text in the search field has changed
  func updateSearchResults(for searchController: UISearchController) {
    if let text = searchController.searchBar.text {
      if text.count > 0 { // only search when there is something in the text field
        //update(text: text)
        tableViewController.update(text: text)
        reload()
      }
    }
  }
  
  

  
}
