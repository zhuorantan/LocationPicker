//
//  LocationPicker.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/28/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import MapKit

public class LocationPicker: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    // MARK: - Completion closures
    
        /**
         Completion closure executed after everytime user select a location.
         - Note:
             This closure would be executed multiple times, because user may change selection before final decision.
             To get user's final decition, use `var pickCompletion` instead.
             Alternatively, you can do the same by:
             * Delegate
             1. conform to `protocol LocationPickerDelegate`
             2. set the `var delegate`
             3. implement `func locationDidSelect(locationItem: LocationItem)`
             * Overrride
             1. create a subclass of `class LocationPicker`
             2. override `func locationDidSelect(locationItem: LocationItem)`
         - SeeAlso:
             * `var pickCompletion: ((LocationItem) -> Void)?`
             * `func locationDidSelect(locationItem: LocationItem)`
             * `protocol LocationPickerDelegate`
        */
    public var selectCompletion: ((LocationItem) -> Void)?
    
        /**
        Completion closure executed after user finally pick a location.
        - Note:
            This closure would be executed once in `func viewWillDisappear(animated: Bool)` before the instance of `LocationPicker` dismissed.
            To get user's every selection, use `var selectCompletion` instead.
            Alternatively, you can do the same by:
            * Delegate
            1. conform to `protocol LocationPickerDelegate`
            2. set the `var delegate`
            3. implement `func locationDidPick(locationItem: LocationItem)`
            * Override
            1. create a subclass of `class LocationPicker`
            2. override `func locationDidPick(locationItem: LocationItem)`
        - SeeAlso:
            * `var selectCompletion: ((LocationItem) -> Void)?`
            * `func locationDidPick(locationItem: LocationItem)`
            * `protocol LocationPickerDelegate`
        */
    public var pickCompletion: ((LocationItem) -> Void)?
    
        /**
        Completion closure executed after user delete a history location.
        - Note:
            This closure would be executed when user delete a location cell from `tableView`.
            User can only delete the location provided in `var historyLocationList` or `dataSource` method `historyLocationAtIndex(index: Int) -> LocationItem`
            Alternatively, you can do the same by 4 steps:
            1. conform to `protocol LocationPickerDataSource`
            2. set the `var dataSource`
            3. implement `func numberOfHistoryLocations() -> Int` to tell the `tableView` how many rows to display
            4. implement `func historyLocationAtIndex(index: Int) -> LocationItem`
     
        - SeeAlso:
            * `func numberOfHistoryLocations() -> Int`
            * `func historyLocationAtIndex(index: Int) -> LocationItem`
            * `protocol LocationPickerDataSource`
        */
    public var deleteCompletion: ((LocationItem) -> Void)?
    
    
    
    // MARK: Optional varaiables
    
    public var delegate: LocationPickerDelegate?
    public var dataSource: LocationPickerDataSource?
    public var historyLocationList: [LocationItem]?
    public var doneButtonItem: UIBarButtonItem? {
        didSet {
            doneButtonItem?.target = self
            doneButtonItem?.action = #selector(doneButtonDidTap(_:))
        }
    }
    
    public var notificationCenter = NSNotificationCenter.defaultCenter()
    
    
    
    // MARK: UI Customs
    
    public var currentLocationText = "Current Location"
    public var searchBarPlaceholder = "Search for location"
    
    public var defaultLongitudinalDistance: Double = 1000
    public var searchLongitudinalDistance: Double = 10000
    
    public var mapViewZoomEnabled = true
    public var mapViewShowsUserLocation = true
    public var mapViewScrollEnabled = true
    public var historyLocationEditable = false
    public var divideSection = false
    
    public var tableViewBackgroundColor = UIColor.whiteColor()
    public var currentLocationColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    public var searchResultLocationColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    public var historyLocationColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    public var pinColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
    public var currentLocationImage: UIImage? = nil
    public var searchResultLocationImage: UIImage? = nil
    public var historyLocationImage: UIImage? = nil
    public var pinImage: UIImage? = nil
    
    
    
    // MARK: - UI Elements
    
    public let searchBar = UISearchBar()
    public let tableView = UITableView()
    public let mapView = MKMapView()
    public let pinView = UIImageView()
    
    
    
    // MARK: Attributes
    
    private var selectedLocationItem: LocationItem?
    private var searchResultList = [LocationItem]()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var longitudinalDistance: Double!
    
    private var mapViewCenterChanged = false
    private var mapViewHeightConstraint: NSLayoutConstraint!
    private var mapViewHeight: CGFloat {
        get {
            return view.frame.width / 3 * 2
        }
    }
    
    private var pinViewCenterYConstraint: NSLayoutConstraint!
    private var pinViewImageHeight: CGFloat {
        get {
            return pinView.image!.size.height
        }
    }
    
    private var historyLocationCount: Int {
        get {
            return historyLocationList?.count ?? dataSource?.numberOfHistoryLocations() ?? 0
        }
    }

    
    
    // MARK: - View Controller
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        longitudinalDistance = defaultLongitudinalDistance
        
        setupLocationManager()
        setupViews()
        layoutViews()
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard doneButtonItem == nil else { return }
        if let locationItem = selectedLocationItem {
            locationDidPick(locationItem)
            notificationCenter.postNotificationName("LocationPick", object: locationItem)
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
        view.backgroundColor = UIColor.whiteColor()
        
        searchBar.delegate = self
        searchBar.placeholder = searchBarPlaceholder
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .OnDrag
        tableView.backgroundColor = tableViewBackgroundColor
        
        mapView.zoomEnabled = mapViewZoomEnabled
        mapView.rotateEnabled = false
        mapView.pitchEnabled = false
        mapView.scrollEnabled = mapViewScrollEnabled
        mapView.showsUserLocation = mapViewShowsUserLocation
        mapView.delegate = self
        
        pinView.image = pinImage ?? StyleKit.imageOfPinIconFilled(color: pinColor)
        
        if mapViewScrollEnabled {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureInMapViewDidRecognize(_:)))
            panGestureRecognizer.delegate = self
            mapView.addGestureRecognizer(panGestureRecognizer)
        }
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(mapView)
        mapView.addSubview(pinView)
    }
    
    private func layoutViews() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        pinView.translatesAutoresizingMaskIntoConstraints = false
        
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

        pinView.centerXAnchor.constraintEqualToAnchor(mapView.centerXAnchor).active = true
        pinViewCenterYConstraint = pinView.centerYAnchor.constraintEqualToAnchor(mapView.centerYAnchor, constant: -pinViewImageHeight / 2)
        pinViewCenterYConstraint.active = true
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
        selectCompletion?(locationItem)
        delegate?.locationDidSelect?(locationItem)
    }
    
    public func locationDidPick(locationItem: LocationItem) {
        pickCompletion?(locationItem)
        delegate?.locationDidPick?(locationItem)
    }
    
    public func historyLocationDidDelete(locationItem: LocationItem) {
        deleteCompletion?(locationItem)
        dataSource?.commitHistoryLocationDeletion?(locationItem)
    }
    
    
    
    // MARK: - Gesture Recognizer
    
    func panGestureInMapViewDidRecognize(sender: UIPanGestureRecognizer) {
        switch(sender.state) {
        case .Began:
            mapViewCenterChanged = true
            selectedLocationItem = nil
            geocoder.cancelGeocode()
            
            searchBar.text = nil
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
            }
            if let doneButtonItem = doneButtonItem {
                doneButtonItem.enabled = false
            }
        default:
            break
        }
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    // MARK: Search Bar Delegate
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = searchText
            
            if let currentCoordinate = locationManager.location?.coordinate {
                localSearchRequest.region = MKCoordinateRegionMakeWithDistance(currentCoordinate, searchLongitudinalDistance, searchLongitudinalDistance)
            }
            MKLocalSearch(request: localSearchRequest).startWithCompletionHandler({ (localSearchResponse, error) -> Void in
                guard error == nil else { return }
                guard let localSearchResponse = localSearchResponse else { return }
                guard localSearchResponse.mapItems.count > 0 else { return }
                
                self.searchResultList = localSearchResponse.mapItems.map({ LocationItem(mapItem: $0) })
                self.tableView.reloadData()
            })
        } else {
            selectedLocationItem = nil
            searchResultList.removeAll()
            tableView.reloadData()
            closeMapView()
            
            if let doneButtonItem = doneButtonItem {
                doneButtonItem.enabled = false
            }
        }
    }
    
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    
    // MAKR: Table View Delegate and Data Source
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + searchResultList.count + historyLocationCount
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: LocationCell!
        
        if indexPath.row == 0 {
            cell = LocationCell(locationType: .CurrentLocation, title: currentLocationText, iconColor: currentLocationColor, iconImage: currentLocationImage)
        } else if indexPath.row > 0 && indexPath.row <= searchResultList.count {
            let index = indexPath.row - 1
            cell = LocationCell(locationType: .SearchLocation, locationItem: searchResultList[index], iconColor: searchResultLocationColor, iconImage: searchResultLocationImage)
        } else if indexPath.row > searchResultList.count && indexPath.row <= historyLocationCount + searchResultList.count {
            let index = indexPath.row - 1 - searchResultList.count
            let locationItem = (historyLocationList?[index] ?? dataSource?.historyLocationAtIndex(index))!
            cell = LocationCell(locationType: .HistoryLocation, locationItem: locationItem, iconColor: historyLocationColor, iconImage: historyLocationImage)
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.endEditing(true)
        longitudinalDistance = defaultLongitudinalDistance
        
        if indexPath.row == 0 {
            if let currentLocation = locationManager.location {
                reverseGeocodeLocation(currentLocation)
            }
        } else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LocationCell
            let locationItem = cell.locationItem!
            selectLocationItem(locationItem)
        }
        
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return historyLocationEditable && indexPath.row > searchResultList.count && indexPath.row <= historyLocationCount + searchResultList.count
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LocationCell
            let locationItem = cell.locationItem!
            let index = indexPath.row - 1 - searchResultList.count
            historyLocationList?.removeAtIndex(index)
            
            historyLocationDidDelete(locationItem)
            notificationCenter.postNotificationName("LocationDelete", object: locationItem)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    
    // MARK: Map View Delegate
    
    public func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if !animated {
            UIView.animateWithDuration(0.35, delay: 0, options: .CurveEaseOut, animations: {
                self.pinView.frame.origin.y -= self.pinViewImageHeight / 2
                }, completion: nil)
        }
    }
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        longitudinalDistance = longitudinalDistanceFromMapRect(mapView.visibleMapRect)
        if mapViewCenterChanged {
            mapViewCenterChanged = false
            let revisedCoordinate = gcj2wgs(mapView.centerCoordinate)
            reverseGeocodeLocation(CLLocation(latitude: revisedCoordinate.latitude, longitude: revisedCoordinate.longitude))
        }
        
        if !animated {
            UIView.animateWithDuration(0.35, delay: 0, options: .CurveEaseOut, animations: {
                self.pinView.frame.origin.y += self.pinViewImageHeight / 2
                }, completion: nil)
        }
    }
    
    
    
    // MARK: Buttons
    
    @objc private func doneButtonDidTap(sender: UIBarButtonItem) {
        if let locationItem = selectedLocationItem {
            dismissViewControllerAnimated(true, completion: nil)
            locationDidPick(locationItem)
            notificationCenter.postNotificationName("LocationPick", object: locationItem)
        }
    }
    
    
    
    // MARK: - UI Mainipulations
    
    private func showMapViewWithCenterCoordinate(coordinate: CLLocationCoordinate2D, WithDistance distance: Double) {
        print("map center changed.")
        mapViewHeightConstraint.constant = mapViewHeight
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0 , distance)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func closeMapView() {
        mapViewHeightConstraint.constant = 0
    }
    
    
    
    // MARK: - Location Manager Delegate
    
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
    
    
    
    // MARK: Location Handlers
    
    private func selectLocationItem(locationItem: LocationItem) {
        selectedLocationItem = locationItem
        searchBar.text = locationItem.name
        let coordinate = coordinateObjectFromTuple(locationItem.coordinate)
        showMapViewWithCenterCoordinate(coordinate, WithDistance: longitudinalDistance)
        
        doneButtonItem?.enabled = true
        locationDidSelect(locationItem)
        notificationCenter.postNotificationName("LocationSelect", object: locationItem)
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
                self.selectLocationItem(LocationItem(mapItem: mapItem))
            }
        })
    }
    
}
