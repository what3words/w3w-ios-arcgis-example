//
//  TableViewController.swift
//  ArcGisExample
//
//  Created by Dave Duprey on 05/10/2022.
//

import Foundation
import UIKit
import W3WSwiftApi


class TableViewController: UITableViewController {
  
  public var onSelected: (Any) -> () = { _ in }
  
  public var onError: (W3WError) -> () = { _ in }
  
  var dataSources = [DataSource]()
  
  var cellHeight = CGFloat(1.0)
  
  
  // MARK: Accessors
  
  
  func add(dataSource: DataSource) {
    dataSources.append(dataSource)
    dataSource.onError = { error in self.onError(error) }
  }
  
  
  func update(text: String) {
    for dataSource in dataSources {
      dataSource.update(text: text)
    }
  }
  
  
  func reload() {
    tableView.reloadData()
  }
  

  func contentHeight() -> CGFloat {
    var heightOfTableView: CGFloat = 0.0

    for dataSource in dataSources {
      heightOfTableView += CGFloat(dataSource.count)
    }
    
    return heightOfTableView * cellHeight
  }

  
  
  // MARK: - Table view delegate
  
  
  /// one way to incorporate what3words suggestions into your autocomplete table, is to
  /// move your results to section one, and use section zero for what3words.
  /// here we return two sections, one for what3words, and one for Apple's address database
  override func numberOfSections(in tableView: UITableView) -> Int {
    return dataSources.count
  }
  
  
  /// return the row count for each section, section zero is what3words, and section one is Apple's addresses
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSources[section].count
  }
  
  
  /// make a cell for the table.  we fill the cell with the what3words suggestion data for section zero, and
  /// with Apple's address data for section one
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    
    cell.textLabel?.text       = dataSources[indexPath.section][indexPath.row].title
    
    let detail = dataSources[indexPath.section][indexPath.row].detail
    if detail.count > 0 {
      cell.detailTextLabel?.text = detail
    }
  
    
    cellHeight = cell.frame.height
    
    return cell
  }
  

  /// call onSelected when an item is selected
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    onSelected(dataSources[indexPath.section][indexPath.row].item)
  }
  
  
  
}
