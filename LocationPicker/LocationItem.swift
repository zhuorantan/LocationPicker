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
    
    public let createTime: NSDate?
    
    
    
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
        self.createTime = NSDate()
    }
    
    
    public init(createTime: NSDate?, name: String, coordinate: (latitude: Double, longitude: Double), addressDictionary: [String: AnyObject]) {
        self.createTime = createTime
        
        let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        self.mapItem = MKMapItem(placemark: placeMark)
    }
}