//
//  Helpers.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/31/16.
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
import MapKit


func coordinateObject(fromTuple coordinateTuple: (latitude: Double, longitude: Double)) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: coordinateTuple.latitude, longitude: coordinateTuple.longitude)
}

func coordinateTuple(fromObject coordinateObject: CLLocationCoordinate2D) -> (latitude: Double, longitude: Double) {
    return (latitude: coordinateObject.latitude, longitude: coordinateObject.longitude)
}


private func isOutsideChina(coordinate: CLLocationCoordinate2D) -> Bool {
    if coordinate.longitude < 72.004 || coordinate.longitude > 137.8347 {
        return true
    }
    if coordinate.latitude < 0.8293 || coordinate.latitude > 55.8271 {
        return true
    }
    return false
}

private func transformLatitude(x: Double, y: Double) -> Double {
    let a = sin(6.0 * x * M_PI), b = sin(2.0 * x * M_PI), c = sin(y * M_PI), d = sin(y / 3.0 * M_PI), e = sin(y / 12.0 * M_PI), f = sin(y * M_PI / 30.0)
    
    var deltaLatitude = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y
    deltaLatitude += 0.1 * x * y + 0.2 * sqrt(abs(x))
    deltaLatitude += (20.0 * a + 20.0 * b) * 2.0 / 3.0
    deltaLatitude += (20.0 * c + 40.0 * d) * 2.0 / 3.0
    deltaLatitude += (160.0 * e + 320 * f) * 2.0 / 3.0
    return deltaLatitude
}

private func transformLongitude(x: Double, y: Double) -> Double {
    let a = sin(6.0 * x * M_PI), b = sin(2.0 * x * M_PI), c = sin(x * M_PI), d = sin(x / 3.0 * M_PI), e = sin(x / 12.0 * M_PI), f = sin(x / 30.0 * M_PI)
    
    var deltaLongitude = 300.0 + x + 2.0 * y + 0.1 * x * x
    deltaLongitude += 0.1 * x * y + 0.1 * sqrt(abs(x))
    deltaLongitude += (20.0 * a + 20.0 * b) * 2.0 / 3.0
    deltaLongitude += (20.0 * c + 40.0 * d) * 2.0 / 3.0
    deltaLongitude += (150.0 * e + 300.0 * f) * 2.0 / 3.0
    return deltaLongitude
}

private func delta(latitude: Double, longitude: Double) -> (Double, Double) {
    let r = 6378245.0
    let ee = 0.00669342162296594323
    let radLatitude = latitude / 180.0 * M_PI
    var magic = sin(radLatitude)
    magic = 1 - ee * magic * magic
    let sqrtMagic = sqrt(magic)
    var deltaLatitude = transformLatitude(x: longitude - 105.0, y: latitude - 35.0)
    var deltaLongitude = transformLongitude(x: longitude - 105.0, y: latitude - 35.0)
    deltaLatitude = (deltaLatitude * 180.0) / ((r * (1 - ee)) / (magic * sqrtMagic) * M_PI)
    deltaLongitude = (deltaLongitude * 180.0) / (r / sqrtMagic * cos(radLatitude) * M_PI)
    return (deltaLatitude, deltaLongitude)
}

func wgsToGcj(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    if isOutsideChina(coordinate: coordinate) {
        return coordinate
    }
    
    let (deltaLatitude, deltaLongitude) = delta(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let revisedCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude + deltaLatitude, longitude: coordinate.longitude + deltaLongitude)
    return revisedCoordinate
}

func gcjToWgs(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    if isOutsideChina(coordinate: coordinate) {
        return coordinate
    }
    
    let (deltaLatitude, deltaLongitude) = delta(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let revisedCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude - deltaLatitude, longitude: coordinate.longitude - deltaLongitude)
    return revisedCoordinate
}


func getLongitudinalDistance(fromMapRect mapRect: MKMapRect) -> Double {
    let westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMidY(mapRect))
    let eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mapRect), MKMapRectGetMidY(mapRect))
    return MKMetersBetweenMapPoints(westMapPoint, eastMapPoint)
}
