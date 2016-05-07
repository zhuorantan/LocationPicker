//
//  PlaceProvider.swift
//  LocationPicker
//
//  Created by James Campbell on 4/25/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import Foundation
import MapKit

public protocol PlaceProvider {
    
    func searchForLocations(searchText: String, region: MKCoordinateRegion?, callback: (items: [LocationItem]) -> Void)
}