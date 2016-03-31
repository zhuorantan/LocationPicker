//
//  Helpers.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/31/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import MapKit

func distanceFromCoordinate(coordinateA: CLLocationCoordinate2D, to coordinateB: CLLocationCoordinate2D) -> CLLocationDistance {
    let locationA = CLLocation(latitude: coordinateA.latitude, longitude: coordinateA.longitude)
    let locationB = CLLocation(latitude: coordinateB.latitude, longitude: coordinateB.longitude)
    return locationA.distanceFromLocation(locationB)
}



func coordinateObjectFromTuple(coordinateTuple: (latitude: Double, longitude: Double)) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: coordinateTuple.latitude, longitude: coordinateTuple.longitude)
}

func coordinateTupleFromObject(coordinateObject: CLLocationCoordinate2D) -> (latitude: Double, longitude: Double) {
    return (latitude: coordinateObject.latitude, longitude: coordinateObject.longitude)
}



private func isCoordinateOutOfChina(coordinate: CLLocationCoordinate2D) -> Bool {
    if coordinate.longitude < 72.004 || coordinate.longitude > 137.8347 {
        return true
    }
    if coordinate.latitude < 0.8293 || coordinate.latitude > 55.8271 {
        return true
    }
    return false
}

private func transformLatitude(_ x: Double, y: Double) -> Double {
    var resetLatitude = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y
    resetLatitude += 0.1 * x * y + 0.2 * sqrt(abs(x))
    resetLatitude += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
    resetLatitude += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
    resetLatitude += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0
    return resetLatitude
}

private func transformLongitude(_ x: Double, y: Double) -> Double {
    var resetLongitude = 300.0 + x + 2.0 * y + 0.1 * x * x
    resetLongitude += 0.1 * x * y + 0.1 * sqrt(abs(x))
    resetLongitude += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
    resetLongitude += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
    resetLongitude += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0
    return resetLongitude
}

//func wgs2gcj(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//    if isCoordinateOutOfChina(coordinate) {
//        return coordinate
//    }
//    
//}