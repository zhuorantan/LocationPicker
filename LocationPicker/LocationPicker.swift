//
//  LocationPicker.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/28/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import MapKit

public class LocationPicker: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: - Completion handlers
    
    public var selectCompletion: ((LocationItem) -> Void)?
    public var pickCompletion: ((LocationItem) -> Void)?
    
    // MARK: Optional varaiables
    
    public var delegate: LocationPickerDelegate?
    public var historyLocationList: [LocationItem]?
    public var doneButtonItem: UIBarButtonItem?
    
    // MARK: Configurations
    
    public var defaultMapViewDistance: Double = 1000
    public var searchRegionDistance: Double = 10000
    
    public var mapViewDraggable = true
    public var historyLocationEditable = true
    public var divideSection = false
    
    public var currentLocationColor = UIColor.blackColor()
    public var searchResultLocationColor = UIColor.blackColor()
    public var historyLocationColor = UIColor.blackColor()
    public var pinColor = UIColor.blackColor()
    
    public var currentLocationImage = UIImage()
    public var searchResultLocationImage = UIImage()
    public var historyLocationImage = UIImage()
    
    
    
    // MARK: - UI Elements
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let mapView = MKMapView()
    
    // MARK: Attributes
    
    private var selectedLocationItem: LocationItem?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var mapViewHeightConstraint: NSLayoutConstraint!
    private var mapViewHeight: CGFloat {
        get {
            return view.frame.width / 3 * 2
        }
    }
    private var isMapViewOpen: Bool {
        get {
            return mapViewHeightConstraint.constant != 0
        }
    }

    
    
    // MARK: - View Controller
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupViews()
        layoutViews()
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let locationItem = selectedLocationItem {
            locationDidPick(locationItem)
        }
    }
    
    
    
    // MARK: Initializations
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestLocation()
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(mapView)
        
        view.backgroundColor = UIColor.whiteColor()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        mapView.zoomEnabled = false
        mapView.rotateEnabled = false
        mapView.pitchEnabled = false
    }
    
    private func layoutViews() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        searchBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        searchBar.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: -view.layoutMargins.left * 2).active = true
        searchBar.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor, constant: view.layoutMargins.right * 2).active = true
        
        tableView.topAnchor.constraintEqualToAnchor(searchBar.bottomAnchor).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(searchBar.leadingAnchor).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(searchBar.trailingAnchor).active = true
        
        mapView.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor).active = true
        mapView.leadingAnchor.constraintEqualToAnchor(tableView.leadingAnchor).active = true
        mapView.trailingAnchor.constraintEqualToAnchor(tableView.trailingAnchor).active = true
        mapView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
        
        mapViewHeightConstraint = mapView.heightAnchor.constraintEqualToConstant(0)
        mapViewHeightConstraint.active = true
    }
    
    
    
    // MARK: - Customs
    
    public func setThemeColor(color: UIColor) {
        currentLocationColor = color
        searchResultLocationColor = color
        historyLocationColor = color
        pinColor = color
    }
    
    
    
    // MARK: - Callbacks
    
    public func locationDidSelect(locationItem: LocationItem) {
        enableDoneButton()
        selectCompletion?(locationItem)
        delegate?.locationDidSelect?(locationItem)
        NSNotificationCenter.defaultCenter().postNotificationName("LocationSelect", object: locationItem)
    }
    
    public func locationDidPick(locationItem: LocationItem) {
        pickCompletion?(locationItem)
        delegate?.locationDidSelect?(locationItem)
        NSNotificationCenter.defaultCenter().postNotificationName("LocationPick", object: locationItem)
    }
    
    
    
    // MAKR: Table View Delegate and Data Source
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = "CurrentLocation"
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if let currentLocation = locationManager.location {
                reverseGeocodeLocation(currentLocation)
            }
        }
    }
    
    
    
    // MARK: - UI Mainipulations
    
    private func enableDoneButton() {
        if let doneButtonItem = doneButtonItem {
            doneButtonItem.enabled = true
        }
    }
    
    private func showMapViewWithCenterCoordinate(coordinate: CLLocationCoordinate2D, WithDistance distance: Double) {
        print("map center changed.")
        mapViewHeightConstraint.constant = mapViewHeight
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0 , distance)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func closeMapView() {
        mapViewHeightConstraint.constant = 0
    }
    
    
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("current location updated.")
        if tableView.indexPathForSelectedRow?.row == 0 {
            let currentLocation = locations[0]
            reverseGeocodeLocation(currentLocation)
        }
    }
    
    private func reverseGeocodeLocation(location: CLLocation) {
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) -> Void in
            guard error == nil else {
                print(error)
                return
            }
            guard let placeMarks = placeMarks else { return }
            
            if !self.searchBar.isFirstResponder() {
                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placeMarks[0]))
                self.selectedLocationItem = LocationItem(mapItem: mapItem)
                self.searchBar.text = mapItem.name
                self.showMapViewWithCenterCoordinate(mapItem.placemark.coordinate, WithDistance: self.defaultMapViewDistance)
            }
        })
    }
    
}
