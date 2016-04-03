//
//  Protocol.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/30/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import Foundation

@objc public protocol LocationPickerDelegate {
    
    optional func locationDidSelect(locationItem: LocationItem)
    optional func locationDidPick(locationItem: LocationItem)
    
}

@objc public protocol LocationPickerDataSource {
    
    func numberOfAlternativeLocations() -> Int
    func alternativeLocationAtIndex(index: Int) -> LocationItem
    optional func commitAlternativeLocationDeletion(locationItem: LocationItem)
    
}