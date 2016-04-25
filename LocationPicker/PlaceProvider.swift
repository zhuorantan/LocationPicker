//
//  PlaceProvider.swift
//  LocationPicker
//
//  Created by James Campbell on 4/25/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import Foundation

public protocol PlaceProvider {
    
    func searchForLocations(searchText: String, callback: (items: [LocationItem]) -> Void)
}