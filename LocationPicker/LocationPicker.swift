//
//  LocationPicker.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/28/16.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Jerome Tan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import MapKit

public class LocationPicker: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Completion closures
    
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
     `var pickCompletion: ((LocationItem) -> Void)?`
     
     `func locationDidSelect(locationItem: LocationItem)`
     
     `protocol LocationPickerDelegate`
     */
    public var selectCompletion: ((LocationItem) -> Void)?
    
    /**
     Completion closure executed after user finally pick a location.
     
     - important:
     If you override `func locationDidPick(locationItem: LocationItem)` without calling `super`, this closure would not be called.
     
     - Note:
     This closure would be executed only once in `func viewWillDisappear(animated: Bool)` before this instance of `LocationPicker` dismissed.
     
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
     `var selectCompletion: ((LocationItem) -> Void)?`
     
     `func locationDidPick(locationItem: LocationItem)`
     
     `protocol LocationPickerDelegate`
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
     `func alternativeLocationDidDelete(locationItem: LocationItem)`
     
     `protocol LocationPickerDataSource`
     */
    public var deleteCompletion: ((LocationItem) -> Void)?
    
    /**
     Handler closure executed when user try to fetch current location without location access.
     
     - important:
     If you override `func locationDidDeny(locationPicker: LocationPicker)` without calling `super`, this closure would not be called.
     
     - Note:
     If this neither this closure is not set and the delegate method with the same purpose is not provided, an alert view controller will be presented, you can configure it using `func setLocationDeniedAlertControllerTitle` or provide a fully cutomized `UIAlertController` to `var locationDeniedAlertController`.
     
     Alternatively, the same result can be achieved by:
     * Delegate
     1. conform to `protocol LocationPickerDelegate`
     2. set the `var delegate`
     3. implement `func locationDidDeny(locationPicker: LocationPicker)`
     * Override
     1. create a subclass of `class LocationPicker`
     2. override `func locationDidDeny(locationPicker: LocationPicker)`
     
     - SeeAlso:
     `func locationDidDeny(locationPicker: LocationPicker)`
     
     `protocol LocationPickerDelegate`
     
     `var locationDeniedAlertController`
     
     `func setLocationDeniedAlertControllerTitle`
     
     */
    public var locationDeniedHandler: ((LocationPicker) -> Void)?
    
    
    
    // MARK: Optional varaiables
    
        /// Delegate of `protocol LocationPickerDelegate`
    public var delegate: LocationPickerDelegate?
    
        /// DataSource of `protocol LocationPickerDataSource`
    public var dataSource: LocationPickerDataSource?
    
    /**
     Locations that show in the location list.
     
     - Note:
     Alternatively, `LocationPicker` can obtain locations via DataSource:
     1. conform to `protocol LocationPickerDataSource`
     2. set the `var dataSource`
     3. implement `func numberOfAlternativeLocations() -> Int` to tell the `tableView` how many rows to display
     4. implement `func alternativeLocationAtIndex(index: Int) -> LocationItem`
     
     - SeeAlso:
     `func numberOfAlternativeLocations() -> Int`
     
     `func alternativeLocationAtIndex(index: Int) -> LocationItem`
     
     `protocol LocationPickerDataSource`
     */
    public var alternativeLocations: [LocationItem]?
    
    /**
     Alert Controller shows when user try to fetch current location without location permission.
     
     - Note:
     If you are content with the default alert controller, don't set this property, just change the text in it by calling `func setLocationDeniedAlertControllerTitle` or change the following text directly.
     
            var locationDeniedAlertTitle
            var locationDeniedAlertMessage
            var locationDeniedGrantText
            var locationDeniedCancelText
     
     - SeeAlso:
     `func setLocationDeniedAlertControllerTitle`
     
     `var locationDeniedHandler: ((LocationPicker) -> Void)?`
     
     `func locationDidDeny(locationPicker: LocationPicker)`
     
     `protocol LocationPickerDelegate`
     */
    public var locationDeniedAlertController: UIAlertController?
    
    
    /**
     Allows the selection of locations that did not match or exactly match search results.
     
     - Note:
     If an arbitrary location is selected, its coordinate in `LocationItem` will be `nil`. __Default__ is __`false`__.
    */
    public var allowArbitraryLocation = false
    
    
    
    // MARK: UI Customizations
    
        /// Text that indicates user's current location. __Default__ is __`"Current Location"`__.
    public var currentLocationText = "Current Location"
    
        /// Text of search bar's placeholder. __Default__ is __`"Search for location"`__.
    public var searchBarPlaceholder = "Search for location"
    
        /// Text of location denied alert title. __Default__ is __`"Location access denied"`__
    public var locationDeniedAlertTitle = "Location access denied"
    
        /// Text of location denied alert message. __Default__ is __`"Grant location access to use current location"`__
    public var locationDeniedAlertMessage = "Grant location access to use current location"
    
        /// Text of location denied alert _Grant_ button. __Default__ is __`"Grant"`__
    public var locationDeniedGrantText = "Grant"
    
        /// Text of location denied alert _Cancel_ button. __Default__ is __`"Cancel"`__
    public var locationDeniedCancelText = "Cancel"
    
    
    
        /// Longitudinal distance in meters that the map view shows when user select a location and before zoom in or zoom out. __Default__ is __`1000`__.
    public var defaultLongitudinalDistance: Double = 1000
    
        /// Distance in meters that is used to search locations. __Default__ is __`10000`__
    public var searchDistance: Double = 10000
    
    
    
        /// `mapView.zoomEnabled` will be set to this property's value after view is loaded. __Default__ is __`true`__
    public var mapViewZoomEnabled = true
    
        /// `mapView.showsUserLocation` is set to this property's value after view is loaded. __Default__ is __`true`__
    public var mapViewShowsUserLocation = true
    
        /// `mapView.scrollEnabled` is set to this property's value after view is loaded. __Default__ is __`true`__
    public var mapViewScrollEnabled = true
    
    /**
     Whether the locations provided in `var alternativeLocations` or obtained from `func alternativeLocationAtIndex(index: Int) -> LocationItem` can be deleted. __Default__ is __`false`__
     - important:
     If this property is set to `true`, remember to update your models by closure, delegate, or override.
     */
    public var alternativeLocationEditable = false
    
    /**
     Whether to force reverse geocoding or not. If this propertyis set to `true`, the location will be reverse geocoded. This is helpful if you require an exact location (e.g. providing street), but the user just searched for a town name.
     The default behavior is to not geocode any additional search result.
     */
    public var forceReverseGeocoding = false
    
    
    
        /// `tableView.backgroundColor` is set to this property's value afte view is loaded. __Default__ is __`UIColor.whiteColor()`__
    public var tableViewBackgroundColor = UIColor.whiteColor()
    
        /// The color of the icon showed in current location cell. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var currentLocationIconColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
        /// The color of the icon showed in search result location cells. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var searchResultLocationIconColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
        /// The color of the icon showed in alternative location cells. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var alternativeLocationIconColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
        /// The color of the pin showed in the center of map view. __Default__ is __`UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)`__
    public var pinColor = UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1)
    
        /// The color of primary text color. __Default__ is __`UIColor(colorLiteralRed: 0.34902, green: 0.384314, blue: 0.427451, alpha: 1)`__
    public var primaryTextColor = UIColor(colorLiteralRed: 0.34902, green: 0.384314, blue: 0.427451, alpha: 1)
    
        /// The color of secondary text color. __Default__ is __`UIColor(colorLiteralRed: 0.541176, green: 0.568627, blue: 0.584314, alpha: 1)`__
    public var secondaryTextColor = UIColor(colorLiteralRed: 0.541176, green: 0.568627, blue: 0.584314, alpha: 1)
    
    
    
        /// The image of the icon showed in current location cell. If this property is set, the `var currentLocationIconColor` won't be adopted.
    public var currentLocationIconImage: UIImage? = nil
    
        /// The image of the icon showed in search result location cells. If this property is set, the `var searchResultLocationIconColor` won't be adopted.
    public var searchResultLocationIconImage: UIImage? = nil
    
        /// The image of the icon showed in alternative location cells. If this property is set, the `var alternativeLocationIconColor` won't be adopted.
    public var alternativeLocationIconImage: UIImage? = nil
    
        /// The image of the pin showed in the center of map view. If this property is set, the `var pinColor` won't be adopted.
    public var pinImage: UIImage? = nil
    
    
    
    // MARK: UI Elements
    
    public let searchBar = UISearchBar()
    public let tableView = UITableView()
    public let mapView = MKMapView()
    public let pinView = UIImageView()
    
    public private(set) var barButtonItems: (doneButtonItem: UIBarButtonItem, cancelButtonItem: UIBarButtonItem)?
    
    
    
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
    private var mapViewCenterChanged = false    // This property is used to record whether the map view center changes. This is neccessary because private func showMapViewWithCenterCoordinate(coordinate: CLLocationCoordinate2D, WithDistance distance: Double) would trigger func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) which calls func reverseGeocodeLocation(location: CLLocation), and this method calls private func showMapViewWithCenterCoordinate(coordinate: CLLocationCoordinate2D, WithDistance distance: Double) back, this would lead to an infinite loop.
    
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

    
    
    // MARK: View Controller
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        longitudinalDistance = defaultLongitudinalDistance
        
        setupLocationManager()
        setupViews()
        layoutViews()
        
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard barButtonItems?.doneButtonItem == nil else { return }
        if let locationItem = selectedLocationItem {
            locationDidPick(locationItem)
        }
    }
    
    
    
    // MARK: Initializations
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.whiteColor()     // the background color of view needs to be set because this color would affect the color of navigation bar if it is translucent.
        
        searchBar.delegate = self
        searchBar.placeholder = searchBarPlaceholder
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as! UITextField
        textFieldInsideSearchBar.textColor = primaryTextColor
        
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
        
        if #available(iOS 9.0, *) {
            searchBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
            searchBar.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
            searchBar.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
            
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
        } else {
            NSLayoutConstraint(item: searchBar, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: searchBar, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: searchBar, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0).active = true
            
            NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: searchBar, attribute: .Bottom, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: searchBar, attribute: .Leading, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: searchBar, attribute: .Trailing, multiplier: 1, constant: 0).active = true
            
            NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: tableView, attribute: .Bottom, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: tableView, attribute: .Leading, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: tableView, attribute: .Trailing, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: 0).active = true
            
            mapViewHeightConstraint = NSLayoutConstraint(item: mapView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 0)
            mapViewHeightConstraint.active = true
            
            NSLayoutConstraint(item: pinView, attribute: .CenterX, relatedBy: .Equal, toItem: mapView, attribute: .CenterX, multiplier: 1, constant: 0).active = true
            pinViewCenterYConstraint = NSLayoutConstraint(item: pinView, attribute: .CenterY, relatedBy: .Equal, toItem: mapView, attribute: .CenterY, multiplier: 1, constant: -pinViewImageHeight / 2)
            pinViewCenterYConstraint.active = true
        }
    }
    
    
    
    // MARK: Customs
    
    /**
     Add two bar buttons that confirm and cancel user's location pick.
     
     - important:
     If this method is called, only when user tap done button can the pick closure, method and delegate method be called.
     If you don't provide `UIBarButtonItem` object, default system style bar button will be used.
     
     - Note:
     You don't need to set the `target` and `action` property of the buttons, `LocationPicker` will handle the dismission of this view controller.
     
     - parameter doneButtonItem:      An `UIBarButtonItem` tapped to confirm selection, default is a _Done_ `barButtonSystemItem`
     - parameter cancelButtonItem:    An `UIBarButtonITem` tapped to cancel selection, default is a _Cancel_ `barButtonSystemItem`
     - parameter doneButtonOrientation: The direction of the done button, default is `.Right`
     */
    public func addBarButtons(doneButtonItem: UIBarButtonItem? = nil,
                           cancelButtonItem: UIBarButtonItem? = nil,
                           doneButtonOrientation: NavigationItemOrientation = .Right) {
        let doneButtonItem = doneButtonItem ?? UIBarButtonItem(barButtonSystemItem: .Done, target: nil, action: nil)
        doneButtonItem.enabled = false
        doneButtonItem.target = self
        doneButtonItem.action = #selector(doneButtonDidTap(_:))
        
        let cancelButtonItem = cancelButtonItem ?? UIBarButtonItem(barButtonSystemItem: .Cancel, target: nil, action: nil)
        cancelButtonItem.target = self
        cancelButtonItem.action = #selector(cancelButtonDidTap(_:))
        
        switch doneButtonOrientation {
        case .Right:
            navigationItem.leftBarButtonItem = cancelButtonItem
            navigationItem.rightBarButtonItem = doneButtonItem
        case .Left:
            navigationItem.leftBarButtonItem = doneButtonItem
            navigationItem.rightBarButtonItem = cancelButtonItem
        }
        
        barButtonItems = (doneButtonItem, cancelButtonItem)
        
    }
    
    /**
     If you are content with the icons provided in `LocaitonPicker` but not with the colors, you can change them by calling this method.
     
     This mehod can also change the color of text color all over the UI.
     
     - Note:
     You can set the color of three icons and the pin in map view by setting the attributes listed below, but to keep the UI consistent, this is not recommanded.
     
            var currentLocationIconColor
            var searchResultLocationIconColor
            var alternativeLocationIconColor
            var pinColor
     
     If you are not satisified with the shape of icons and pin image, you can change them by setting the attributes below.
     
            var currentLocationIconImage
            var searchResultLocationIconImage
            var alternativeLocationIconImage
            var pinImage
     
     - parameter themeColor:         The color of all icons
     - parameter primaryTextColor:   The color of primary text
     - parameter secondaryTextColor: The color of secondary text
     */
    public func setColors(themeColor: UIColor? = nil, primaryTextColor: UIColor? = nil, secondaryTextColor: UIColor? = nil) {
        self.currentLocationIconColor = themeColor ?? self.currentLocationIconColor
        self.searchResultLocationIconColor = themeColor ?? self.searchResultLocationIconColor
        self.alternativeLocationIconColor = themeColor ?? self.alternativeLocationIconColor
        self.pinColor = themeColor ?? self.pinColor
        self.primaryTextColor = primaryTextColor ?? self.primaryTextColor
        self.secondaryTextColor = secondaryTextColor ?? self.secondaryTextColor
    }
    
    /**
     Set text of alert controller presented when user try to get current location but denied app's authorization.
     
     If you are content with the default alert controller provided by `LocationPicker`, just call this method to change the alert text to your any language you like.
     
     - Note: 
     If you are not satisfied with the default alert controller, just set `var locationDeniedAlertController` to your fully customized alert controller. If you don't want to present an alert controller at all in such situation, you can customize the behavior of `LocationPicker` by setting closure, using delegate or overriding.
     
     - parameter title:      Text of location denied alert title
     - parameter message:    Text of location denied alert message
     - parameter grantText:  Text of location denied alert _Grant_ button text
     - parameter cancelText: Text of location denied alert _Cancel_ button text
     */
    public func setLocationDeniedAlertControllerTitle(title: String? = nil, message: String? = nil, grantText: String? = nil, cancelText: String? = nil) {
        self.locationDeniedAlertTitle = title ?? self.locationDeniedAlertTitle
        self.locationDeniedAlertMessage = message ?? self.locationDeniedAlertMessage
        self.locationDeniedGrantText = grantText ?? self.locationDeniedGrantText
        self.locationDeniedCancelText = cancelText ?? self.locationDeniedCancelText
    }
    
    
    
    /**
     Decide if an item from MKLocalSearch should be displayed or not
     
     - parameter locationItem:      An instance of `LocationItem`
     */
    public func shouldShowSearchResult(mapItem: MKMapItem) -> Bool {
        return true
    }
    
    
    
    // MARK: Gesture Recognizer
    
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
            if let doneButtonItem = barButtonItems?.doneButtonItem {
                doneButtonItem.enabled = false
            }
        default:
            break
        }
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    // MARK: Buttons
    
    func doneButtonDidTap(sender: UIBarButtonItem) {
        if let locationItem = selectedLocationItem {
            dismissViewControllerAnimated(true, completion: nil)
            locationDidPick(locationItem)
        }
    }
    
    func cancelButtonDidTap(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: UI Mainipulations
    
    private func showMapViewWithCenterCoordinate(coordinate: CLLocationCoordinate2D, WithDistance distance: Double) {
        mapViewHeightConstraint.constant = mapViewHeight
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 0 , distance)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func closeMapView() {
        mapViewHeightConstraint.constant = 0
    }
    
    
    
    // MARK: Location Handlers
    
    /**
     Set the given LocationItem as the currently selected one. This will update the searchBar and show the map if possible.
     
     - parameter locationItem:      An instance of `LocationItem`
     */
    public func selectLocationItem(locationItem: LocationItem) {
        selectedLocationItem = locationItem
        searchBar.text = locationItem.name
        if let coordinate = locationItem.coordinate {
            showMapViewWithCenterCoordinate(coordinateObjectFromTuple(coordinate), WithDistance: longitudinalDistance)
        } else {
            closeMapView()
        }
        
        barButtonItems?.doneButtonItem.enabled = true
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

extension LocationPicker {
    
    // MARK: Callbacks
    
    /**
     This method would be called everytime user select a location including the change of region of the map view.
     
     - important:
     This method includes the following codes:
     
     selectCompletion?(locationItem)
     delegate?.locationDidSelect?(locationItem)
     
     So, if you override it without calling `super.locationDidSelect(locationItem)`, completion closure and delegate method would not be called.
     
     - Note:
     This method would be called multiple times, because user may change selection before final decision.
     
     To do something with user's final decition, use `func locationDidPick(locationItem: LocationItem)` instead.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var selectCompletion`
     * Delegate
     1. conform to `protocol LocationPickerDelegate`
     2. set the `var delegate`
     3. implement `func locationDidPick(locationItem: LocationItem)`
     
     - SeeAlso:
     `var selectCompletion: ((LocationItem) -> Void)?`
     
     `func locationDidPick(locationItem: LocationItem)`
     
     `protocol LocationPickerDelegate`
     
     - parameter locationItem: The location item user selected
     */
    public func locationDidSelect(locationItem: LocationItem) {
        selectCompletion?(locationItem)
        delegate?.locationDidSelect?(locationItem)
    }
    
    /**
     This method would be called after user finally pick a location.
     
     - important:
     This method includes the following codes:
     
     pickCompletion?(locationItem)
     delegate?.locationDidPick?(locationItem)
     
     So, if you override it without calling `super.locationDidPick(locationItem)`, completion closure and delegate method would not be called.
     
     - Note:
     This method would be called only once in `func viewWillDisappear(animated: Bool)` before this instance of `LocationPicker` dismissed.
     
     To get user's every selection, use `func locationDidSelect(locationItem: LocationItem)` instead.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var pickCompletion`
     * Delegate
     1. conform to `protocol LocationPickerDelegate`
     2. set the `var delegate`
     3. implement `func locationDidPick(locationItem: LocationItem)`
     
     - SeeAlso:
     `var pickCompletion: ((LocationItem) -> Void)?`
     
     `func locationDidSelect(locationItem: LocationItem)`
     
     `protocol LocationPickerDelegate`
     
     - parameter locationItem: The location item user picked
     */
    public func locationDidPick(locationItem: LocationItem) {
        pickCompletion?(locationItem)
        delegate?.locationDidPick?(locationItem)
    }
    
    /**
     This method would be called after user delete an alternative location.
     
     - important:
     This method includes the following codes:
     
     deleteCompletion?(locationItem)
     dataSource?.commitAlternativeLocationDeletion?(locationItem)
     
     So, if you override it without calling `super.alternativeLocationDidDelete(locationItem)`, completion closure and delegate method would not be called.
     
     - Note:
     This method would be called when user delete a location cell from `tableView`.
     
     User can only delete the location provided in `var alternativeLocations` or `dataSource` method `alternativeLocationAtIndex(index: Int) -> LocationItem`.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var deleteCompletion`
     * Delegate
     1. conform to `protocol LocationPickerDataSource`
     2. set the `var dataSource`
     3. implement `func commitAlternativeLocationDeletion(locationItem: LocationItem)`
     
     - SeeAlso:
     `var deleteCompletion: ((LocationItem) -> Void)?`
     
     `protocol LocationPickerDataSource`
     
     - parameter locationItem: The location item needs to be deleted
     */
    public func alternativeLocationDidDelete(locationItem: LocationItem) {
        deleteCompletion?(locationItem)
        dataSource?.commitAlternativeLocationDeletion?(locationItem)
    }
    
    /**
     This method would be called when user try to fetch current location without granting location access.
     
     - important:
     This method includes the following codes:
     
     locationDeniedHandler?(self)
     delegate?.locationDidDeny?(self)
     
     So, if you override it without calling `super.locationDidDeny(locationPicker)`, completion closure and delegate method would not be called.
     
     - Note:
     If you wish to present an alert view controller, just ignore this method. You can provide a fully cutomized `UIAlertController` to `var locationDeniedAlertController`, or configure the alert view controller provided by `LocationPicker` using `func setLocationDeniedAlertControllerTitle`.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var locationDeniedHandler`
     * Delegate
     1. conform to `protocol LocationPickerDelegate`
     2. set the `var delegate`
     3. implement `func locationDidDeny(locationPicker: LocationPicker)`
     
     - SeeAlso:
     `var locationDeniedHandler: ((LocationPicker) -> Void)?`
     
     `protocol LocationPickerDelegate`
     
     `var locationDeniedAlertController`
     
     `func setLocationDeniedAlertControllerTitle`
     
     - parameter locationPicker `LocationPicker` instance that needs to response to user's location request
     */
    public func locationDidDeny(locationPicker: LocationPicker) {
        locationDeniedHandler?(self)
        delegate?.locationDidDeny?(self)
        
        if locationDeniedHandler == nil && delegate?.locationDidDeny == nil {
            if let alertController = locationDeniedAlertController {
                presentViewController(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: locationDeniedAlertTitle, message: locationDeniedAlertMessage, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: locationDeniedGrantText, style: .Default, handler: { (alertAction) in
                    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }))
                alertController.addAction(UIAlertAction(title: locationDeniedCancelText, style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
}

extension LocationPicker: UISearchBarDelegate {
    
    // MARK: Search Bar Delegate
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = searchText
            
            if let currentCoordinate = locationManager.location?.coordinate {
                localSearchRequest.region = MKCoordinateRegionMakeWithDistance(currentCoordinate, searchDistance, searchDistance)
            }
            MKLocalSearch(request: localSearchRequest).startWithCompletionHandler({ (localSearchResponse, error) -> Void in
                guard error == nil,
                    let localSearchResponse = localSearchResponse where localSearchResponse.mapItems.count > 0 else {
                        if self.allowArbitraryLocation {
                            let locationItem = LocationItem(locationName: searchText)
                            self.searchResultLocations = [locationItem]
                        } else {
                            self.searchResultLocations = []
                        }
                        self.tableView.reloadData()
                        return
                }
                
                self.searchResultLocations = localSearchResponse.mapItems.filter({ (mapItem) -> Bool in
                    return self.shouldShowSearchResult(mapItem)
                }).map({ LocationItem(mapItem: $0) })
                
                if self.allowArbitraryLocation {
                    let locationFound = self.searchResultLocations.filter({
                        $0.name.lowercaseString == searchText.lowercaseString}).count > 0
                    
                    if !locationFound {
                        // Insert arbitrary location without coordinate
                        let locationItem = LocationItem(locationName: searchText)
                        self.searchResultLocations.insert(locationItem, atIndex: 0)
                    }
                }
                
                self.tableView.reloadData()
            })
        } else {
            selectedLocationItem = nil
            searchResultLocations.removeAll()
            tableView.reloadData()
            closeMapView()
            
            if let doneButtonItem = barButtonItems?.doneButtonItem {
                doneButtonItem.enabled = false
            }
        }
    }
    
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension LocationPicker: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Table View Delegate and Data Source
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + searchResultLocations.count + alternativeLocationCount
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: LocationCell!
        
        if indexPath.row == 0 {
            cell = LocationCell(locationType: .CurrentLocation, locationItem: nil)
            cell.locationNameLabel.text = currentLocationText
            cell.iconView.image = currentLocationIconImage ?? StyleKit.imageOfMapPointerIcon(color: currentLocationIconColor)
        } else if indexPath.row > 0 && indexPath.row <= searchResultLocations.count {
            let index = indexPath.row - 1
            cell = LocationCell(locationType: .SearchLocation, locationItem: searchResultLocations[index])
            cell.iconView.image = searchResultLocationIconImage ?? StyleKit.imageOfSearchIcon(color: searchResultLocationIconColor)
        } else if indexPath.row > searchResultLocations.count && indexPath.row <= alternativeLocationCount + searchResultLocations.count {
            let index = indexPath.row - 1 - searchResultLocations.count
            let locationItem = (alternativeLocations?[index] ?? dataSource?.alternativeLocationAtIndex(index))!
            cell = LocationCell(locationType: .AlternativeLocation, locationItem: locationItem)
            cell.iconView.image = alternativeLocationIconImage ?? StyleKit.imageOfPinIcon(color: alternativeLocationIconColor)
        }
        cell.locationNameLabel.textColor = primaryTextColor
        cell.locationAddressLabel.textColor = secondaryTextColor
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.endEditing(true)
        longitudinalDistance = defaultLongitudinalDistance
        
        if indexPath.row == 0 {
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .Denied:
                locationDidDeny(self)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                
            default:
                break
            }
            
            if let currentLocation = locationManager.location {
                reverseGeocodeLocation(currentLocation)
            }
        } else {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! LocationCell
            let locationItem = cell.locationItem!
            let coordinate = locationItem.coordinate
            if (coordinate != nil && self.forceReverseGeocoding) {
                reverseGeocodeLocation(CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude))
            } else {
                selectLocationItem(locationItem)
            }
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
    
}

extension LocationPicker: MKMapViewDelegate {
    
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
    
}

extension LocationPicker: CLLocationManagerDelegate {
    
    // MARK: Location Manager Delegate
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if tableView.indexPathForSelectedRow?.row == 0 {
            let currentLocation = locations[0]
            reverseGeocodeLocation(currentLocation)
            if #available(iOS 9.0, *) {
            } else {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
}
