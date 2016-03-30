//
//  CustomLocationPicker.swift
//  LocationPickerExample
//
//  Created by Jerome Tan on 3/30/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import MapKit
import LocationPicker

class CustomLocationPicker: LocationPicker {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func locationDidSelect(mapItem: MKMapItem) {
        
    }
    
    override func locationDidPick(mapItem: MKMapItem) {
        (parentViewController! as! ViewController).showLocation(mapItem)
    }

}
