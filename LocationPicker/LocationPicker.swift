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
     
         - important:
             If you override `func locationDidSelect(locationItem: LocationItem)` without calling `super`, this closure would not be called.
     
         - Note:
             This closure would be executed multiple times, because user may change selection before final decision.
     
             To get user's final decition, use `var pickCompletion` instead.
     
             Alternatively, the same result can be achieved by:
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
     
         - important:
             If you override `func locationDidPick(locationItem: LocationItem)` without calling `super`, this closure would not be called.
     
         - Note:
             This closure would be executed only once in `func viewWillDisappear(animated: Bool)` before the instance of `LocationPicker` dismissed.
     
             To get user's every selection, use `var selectCompletion` instead.
     
             Alternatively, the same result can be achieved by:
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
         Completion closure executed after user delete an alternative location.
     
         - important:
             If you override `func alternativeLocationDidDelete(locationItem: LocationItem)` without calling `super`, this closure would not be called.
     
         - Note:
             This closure would be executed when user delete a location cell from `tableView`.
     
             User can only delete the location provided in `var alternativeLocations` or `dataSource` method `alternativeLocationAtIndex(index: Int) -> LocationItem`.
     
             Alternatively, the same result can be achieved by:
             * Delegate
             1. conform to `protocol LocationPickerDataSource`
             2. set the `var dataSource`
             3. implement `func commitAlternativeLocationDeletion(locationItem: LocationItem)`
             * Override
             1. create a subclass of `class LocationPicker`
             2. override `func alternativeLocationDidDelete(locationItem: LocationItem)`
     
         - SeeAlso:
             * `func alternativeLocationDidDelete(locationItem: LocationItem)`
             * `protocol LocationPickerDataSource`
        */
    public var deleteCompletion: ((LocationItem) -> Void)?
    
    
    
    // MARK: Optional varaiables
    
        /// Delegate of `protocol LocationPickerDelegate`
    public var delegate: LocationPickerDelegate?
    
        /// DataSource of `protocol LocationPickerDataSource`
    public var dataSource: LocationPickerDataSource?
    
        /**
         Locations that show in the location list.
     
         - Note:
             Alternatively, `LocationPicker` can obtain locations by DataSource:
             1. conform to `protocol LocationPickerDataSource`
             2. set the `var dataSource`
             3. implement `func numberOfAlternativeLocations() -> Int` to tell the `tableView` how many rows to display
             4. implement `func alternativeLocationAtIndex(index: Int) -> LocationItem`
     
         - SeeAlso:
             * `func numberOfAlternativeLocations() -> Int`
             * `func alternativeLocationAtIndex(index: Int) -> LocationItem`
             * `protocol LocationPickerDataSource`
        */
    public var alternativeLocations: [LocationItem]?
    
        /**
         Button that confirms user's location pick.
     
         - important:
             If this property is specified, only when user tap this button can the pick closure, method and delegate method be called.
     
         - Note:
             You don't need to set the `target` and `action` of this `UIBarButtonItem` object, just customize the button as you like, and `LocationPicker` will do the rest, inculuding dismissing the view controller.
        */
    public var doneButtonItem: UIBarButtonItem? {
        didSet {
            doneButtonItem?.target = self
            doneButtonItem?.action = #selector(doneButtonDidTap(_:))
        }
    }
    
    
    
    // MARK: UI Customizations
    
        /// Text that indicates user's current location. __Default__ is __`"Current Location"`__.
    public var currentLocationText = "Current Location"
    
        /// Text of search bar's placeholder. __Default__ is __`"Search for location"`__.
    public var searchBarPlaceholder = "Search for location"
    
    
    
        /// Longitudinal distance in meters that the map view shows when user select a location and before zoom in or zoom out. __Default__ is __`1000`__.
    public var defaultLongitudinalDistance: Double = 1000
    
        /// Distance in meters that is used to search locations. __Default__ is __`10000`__
    public var searchDistance: Double = 10000
    
    
    
        /// In `func viewDidLoad()`, `mapView.zoomEnabled` is set to this property's value. __Default__ is __`true`__
    public var mapViewZoomEnabled = true
    
        /// In `func viewDidLoad()`, `mapView.showsUserLocation` is set to this property's value. __Default__ is __`true`__
    public var mapViewShowsUserLocation = true
    
        /// In `func viewDidLoad()`, `mapView.scrollEnabled` is set to this property's value. __Default__ is __`true`__
    public var mapViewScrollEnabled = true
    
        /**
         Whether the locations provided in `var alternativeLocations` or obtained from `func alternativeLocationAtIndex(index: Int) -> LocationItem` can be deleted. __Default__ is __`false`__
         - important:
             If this property is set to `true`, remember to update your models by closure, delegate, or override.
        */
    public var alternativeLocationEditable = false
    
    
    
        /// In `func viewDidLoad()`, `tableView.backgroundColor` is set to this property's value. __Default__ is __`UIColor.whiteColor()`__
    public var tableViewBackgroundColor = UIColor.whiteColor()
    
        /// The color of the icon showed in current location cell. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var currentLocationIconColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
        /// The color of the icon showed in search result location cells. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var searchResultLocationIconColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
        /// The color of the icon showed in alternative location cells. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var alternativeLocationIconColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
        /// The color of the pin showed in the center of map view. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var pinColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
    
    
        /// The image of the icon showed in current location cell. If this property is set, the `var currentLocationIconColor` won't be adopted.
    public var currentLocationIconImage: UIImage? = nil
    
        /// The image of the icon showed in search result location cells. If this property is set, the `var searchResultLocationIconColor` won't be adopted.
    public var searchResultLocationIconImage: UIImage? = nil
    
        /// The image of the icon showed in alternative location cells. If this property is set, the `var alternativeLocationIconColor` won't be adopted.
    public var alternativeLocationIconImage: UIImage? = nil
    
        /// The image of the pin showed in the center of map view. If this property is set, the `var pinColor` won't be adopted.
    public var pinImage: UIImage? = nil
    
    
    
    // MARK: - UI Elements
    
    public let searchBar = UISearchBar()
    public let tableView = UITableView()
    public let mapView = MKMapView()
    public let pinView = UIImageView()
    
    
    
    // MARK: Attributes
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var selectedLocationItem: LocationItem?
    private var searchResultLocations = [LocationItem]()
    
    private var alternativeLocationCount: Int {
        get {
            return alternativeLocations?.count ?? dataSource?.numberOfAlternativeLocations() ?? 0
        }
    }
    
    private var longitudinalDistance: Double!   // This property is used to record the longitudinal distance of the map view. This is neccessary because when user zoom in or zoom out the map view, func showMapViewWithCenterCoordinate(coordinate: CLLocationCoordinate2D, WithDistance distance: Double) will reset the region of the map view.
    private var mapViewCenterChanged = false    // This property is used to record whether the map view center changes. This is neccessary because reverseGeocodeLocation(location: CLLocation) would trigger func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) which calls func reverseGeocodeLocation(location: CLLocation) back, this would become a endless loop.
    
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
        currentLocationIconColor = color
        searchResultLocationIconColor = color
        alternativeLocationIconColor = color
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
    
    public func alternativeLocationDidDelete(locationItem: LocationItem) {
        deleteCompletion?(locationItem)
        dataSource?.commitAlternativeLocationDeletion?(locationItem)
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
                localSearchRequest.region = MKCoordinateRegionMakeWithDistance(currentCoordinate, searchDistance, searchDistance)
            }
            MKLocalSearch(request: localSearchRequest).startWithCompletionHandler({ (localSearchResponse, error) -> Void in
                guard error == nil else { return }
                guard let localSearchResponse = localSearchResponse else { return }
                guard localSearchResponse.mapItems.count > 0 else { return }
                
                self.searchResultLocations = localSearchResponse.mapItems.map({ LocationItem(mapItem: $0) })
                self.tableView.reloadData()
            })
        } else {
            selectedLocationItem = nil
            searchResultLocations.removeAll()
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
        return 1 + searchResultLocations.count + alternativeLocationCount
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: LocationCell!
        
        if indexPath.row == 0 {
            cell = LocationCell(locationType: .CurrentLocation, title: currentLocationText, iconColor: currentLocationIconColor, iconImage: currentLocationIconImage)
        } else if indexPath.row > 0 && indexPath.row <= searchResultLocations.count {
            let index = indexPath.row - 1
            cell = LocationCell(locationType: .SearchLocation, locationItem: searchResultLocations[index], iconColor: searchResultLocationIconColor, iconImage: searchResultLocationIconImage)
        } else if indexPath.row > searchResultLocations.count && indexPath.row <= alternativeLocationCount + searchResultLocations.count {
            let index = indexPath.row - 1 - searchResultLocations.count
            let locationItem = (alternativeLocations?[index] ?? dataSource?.alternativeLocationAtIndex(index))!
            cell = LocationCell(locationType: .AlternativeLocation, locationItem: locationItem, iconColor: alternativeLocationIconColor, iconImage: alternativeLocationIconImage)
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
        return alternativeLocationEditable && indexPath.row > searchResultLocations.count && indexPath.row <= alternativeLocationCount + searchResultLocations.count
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LocationCell
            let locationItem = cell.locationItem!
            let index = indexPath.row - 1 - searchResultLocations.count
            alternativeLocations?.removeAtIndex(index)
            
            alternativeLocationDidDelete(locationItem)
            
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
