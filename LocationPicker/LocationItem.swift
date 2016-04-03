//
//  LocationItem.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/30/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import MapKit

public class LocationItem: NSObject, NSCoding {
    
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
    
    public var formattedAddressString: String? {
        get {
            return (addressDictionary?["FormattedAddressLines"] as? [String])?[0]
        }
    }
    
    
    
    public override var hashValue: Int {
        get {
            return "\(coordinate.latitude), \(coordinate.longitude)".hashValue
        }
    }
    
    public override var description: String {
        get {
            return "Location item with map item: " + mapItem.description
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
    
    public override func isEqual(object: AnyObject?) -> Bool {
        return object?.hashValue == hashValue
    }
    
    
    
    public required convenience init(coder decoder: NSCoder) {
        let latitude = decoder.decodeObjectForKey("latitude") as! Double
        let longitude = decoder.decodeObjectForKey("longitude") as! Double
        let addressDictionary = decoder.decodeObjectForKey("addressDictionary") as! [String: AnyObject]
        self.init(coordinate: (latitude, longitude), addressDictionary: addressDictionary)
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(coordinate.latitude, forKey: "latitude")
        coder.encodeObject(coordinate.longitude, forKey: "longitude")
        coder.encodeObject(addressDictionary, forKey: "addressDictionary")
    }
    
}