//
//  Protocol.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/30/16.
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

import Foundation

/**
 All methods of this protocol are optional, they allow the delegate to perform actions.
 */
@objc public protocol LocationPickerDelegate {
    
    /**
     This delegate method would be called everytime user select a location including the change of region of the map view.
     
     - Note:
     This method would be called multiple times, because user may change selection before final decision.
     
     To do something with user's final decition, use `func locationDidPick(locationItem: LocationItem)` instead.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var selectCompletion`
     * Overrride
     1. create a subclass of `class LocationPicker`
     2. override `func locationDidSelect(locationItem: LocationItem)`
     
     - SeeAlso:
     `var selectCompletion: ((LocationItem) -> Void)?`
     
     `func locationDidPick(locationItem: LocationItem)`
     
     `protocol LocationPickerDataSource`
     
     - parameter locationItem: The location item user selected
     */
    @objc optional func locationDidSelect(locationItem: LocationItem)
    
    /**
     This delegate method would be called after user finally pick a location.
     
     - Note:
     This method would be called only once in `func viewWillDisappear(animated: Bool)` before this instance of `LocationPicker` dismissed.
     
     To get user's every selection, use `func locationDidSelect(locationItem: LocationItem)` instead.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var pickCompletion`
     * Override
     1. create a subclass of `class LocationPicker`
     2. override `func locationDidPick(locationItem: LocationItem)`
     
     - SeeAlso:
     `var pickCompletion: ((LocationItem) -> Void)?`
     
     `func locationDidSelect(locationItem: LocationItem)`
     
     `protocol LocationPickerDataSource`
     
     - parameter locationItem: The location item user picked
     */
    @objc optional func locationDidPick(locationItem: LocationItem)
    
    /**
     This delegate method would be called when user try to fetch current location without granting location access.
     
     - Note:
     If you wish to present an alert view controller, just ignore this method. You can provide a fully cutomized `UIAlertController` to `var locationDeniedAlertController`, or configure the alert view controller provided by `LocationPicker` using `func setLocationDeniedAlertControllerTitle`.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var locationDeniedHandler`
     * Override
     1. create a subclass of `class LocationPicker`
     2. override `func locationDidDeny(locationPicker: LocationPicker)`
     
     - SeeAlso:
     `var locationDeniedHandler: ((LocationPicker) -> Void)?`
     
     `protocol LocationPickerDataSource`
     
     `var locationDeniedAlertController`
     
     `func setLocationDeniedAlertControllerTitle`
     
     - parameter locationPicker `LocationPicker` instance that needs to response to user's location request
     */
    @objc optional func locationDidDeny(locationPicker: LocationPicker)
    
}

@objc public protocol LocationPickerDataSource {
    
    /**
     Tell the `tableView` of `LocationPicker` how many locations you want to add to the location list.
     
     - returns: The number of locations you would like to display in the list
     */
    func numberOfAlternativeLocations() -> Int
    
    /**
     Provide the location item to the location list.
     
     - parameter index: The index of the location item
     
     - returns: The location item in the specific index
     */
    func alternativeLocation(at index: Int) -> LocationItem
    
    /**
     This delegate method would be called after user delete an alternative location.
     
     - Note:
     This method would be called when user delete a location cell from `tableView`.
     
     User can only delete the location provided in `var alternativeLocations` or `dataSource` method `alternativeLocationAtIndex(index: Int) -> LocationItem`.
     
     Alternatively, the same result can be achieved by:
     * Closure
     1. set `var deleteCompletion`
     * Override
     1. create a subclass of `class LocationPicker`
     2. override `func alternativeLocationDidDelete(locationItem: LocationItem)`
     
     - SeeAlso:
     `var deleteCompletion: ((LocationItem) -> Void)?`
     
     `protocol LocationPickerDelegate`
     
     - parameter locationItem: The location item needs to be deleted
     */
    @objc optional func commitAlternativeLocationDeletion(locationItem: LocationItem)
    
}
