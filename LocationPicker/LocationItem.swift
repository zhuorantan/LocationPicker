//
//  LocationItem.swift
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