![what3words](https://circleci.com/gh/what3words/w3w-swift-wrapper.svg?style=shield&branch=master)

# <img valign='top' src="https://what3words.com/assets/images/w3w_square_red.png" width="64" height="64" alt="what3words">&nbsp;w3w-ios-arcgis-example 

An example of what3words and ArcGIS libraries working together 

## Overview

This is a simple app based in a single `UIViewController` called `ViewController`.

It shows a custom search controller text field over a customised ArcGIS map, both of which have knowledge of ArcGIS and what3words data.

## Architecture:

##### Map

There is an ArcGIS map called `W3WAGSMapView` which is derived from `AGSMapView`.  

It adds `addMarker(at:)` functions which accept a what3words `W3WSquare`, `W3WSuggestion`, `CLLocationCoordinate2D`, `AGSGeocodeResult`, `AGSPoint`, or a  `String` contianing a three word address.

These `addMarker(at:)` functions place an ArcGIS `AGSGraphic` pin on the map. 

##### Views

There is a `UISearchController` called `SearchController` which contains a `UITableViewController` called `TableViewController` that handles both what3words data and ArcGIS data, and displays them as suggestions.

##### Data

The what3words, and ArcGIS data are represented by classes derived from a custom `DataSource` class.  They are `AutosuggestDataSource` and `ArcGISDataSource`.  These are designed to be consumed by `TableViewController`.

## SDK versus API

The `W3WAGSMapView` and the `ArcGISDataSource` both need access to what3words data.  In this example we use the API for simplicity sake, but the SDK can also be used instead.