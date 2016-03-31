//
//  LocationItem.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/30/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import MapKit

public class LocationItem: NSObject {
    
    public let mapItem: MKMapItem
    
    
    
    public var name: String {
        get {
            return mapItem.name ?? ""
        }
    }
    public var coordinate: (latitude: Double, longitude: Double) {
        get {
            let coordinate = mapItem.placemark.coordinate
            return (coordinate.latitude, coordinate.longitude)
        }
    }
    public var addressDictionary: [NSObject: AnyObject]? {
        get {
            return mapItem.placemark.addressDictionary
        }
    }
    
    public init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    
    public init(coordinate: (latitude: Double, longitude: Double), addressDictionary: [String: AnyObject]) {
        let coordinateObject = coordinateObjectFromTuple(coordinate)
        let placeMark = MKPlacemark(coordinate: coordinateObject, addressDictionary: addressDictionary)
        self.mapItem = MKMapItem(placemark: placeMark)
    }
}