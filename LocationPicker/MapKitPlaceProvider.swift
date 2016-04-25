//
//  MapKitPlaceProvider.swift
//  LocationPicker
//
//  Created by James Campbell on 4/25/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import MapKit

public class MapKitPlaceProvider: PlaceProvider {
    
    public func searchForLocations(searchText: String, callback: (items: [LocationItem]) -> Void) {
        
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchText
        
//        if let currentCoordinate = locationManager.location?.coordinate {
//            localSearchRequest.region = MKCoordinateRegionMakeWithDistance(currentCoordinate, searchDistance, searchDistance)
//        }
        
        MKLocalSearch(request: localSearchRequest).startWithCompletionHandler({ (localSearchResponse, error) -> Void in
            guard error == nil else { return }
            guard let localSearchResponse = localSearchResponse else { return }
            guard localSearchResponse.mapItems.count > 0 else { return }
            
            callback(items: localSearchResponse.mapItems.map({ LocationItem(mapItem: $0) }))
        })
    }
}