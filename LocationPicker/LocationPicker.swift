//
//  LocationPicker.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/28/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import MapKit

public class LocationPicker: UIViewController {
    
    // MARK: - Completion handlers
    
    public var selectCompletion: ((LocationItem) -> Void)?
    public var pickCompletion: ((LocationItem) -> Void)?
    
    // MARK: Optional varaiables
    
    public var delegate: LocationPickerDelegate?
    public var historyLocationList: [LocationItem]?
    public var doneButtonItem: UIBarButtonItem?
    
    // MARK: Configurations
    
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
    
    private var mapViewHeightConstraint: NSLayoutConstraint!
    private var mapViewHeight: CGFloat {
        get {
            return view.frame.width / 3 * 2
        }
    }

    
    
    // MARK: - View Controller
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
        showMapViewCenterCoordinate(CLLocationCoordinate2D(latitude: 31.31527778, longitude: 121.3825), WithDistance: 1000)
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let locationItem = selectedLocationItem {
            locationDidPick(locationItem)
        }
    }
    
    
    
    // MARK: Initializations
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(mapView)
        
        view.backgroundColor = UIColor.whiteColor()
        
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
    
    
    
    // MARK: - UI Mainipulations
    
    private func enableDoneButton() {
        if let doneButtonItem = doneButtonItem {
            doneButtonItem.enabled = true
        }
    }
    
    private func showMapViewCenterCoordinate(coordinate: CLLocationCoordinate2D, WithDistance distance: Double) {
        mapViewHeightConstraint.constant = mapViewHeight
        
        let revisedCoordinate = wgs2gcj(coordinate)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(revisedCoordinate, 0 , distance)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func closeMapView() {
        mapViewHeightConstraint.constant = 0
    }
    
}
