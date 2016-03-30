//
//  CustomLocationPicker.swift
//  LocationPickerExample
//
//  Created by Jerome Tan on 3/30/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import LocationPicker

class CustomLocationPicker: LocationPicker {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func locationDidSelect(locationItem: LocationItem) {
        
    }
    
    override func locationDidPick(locationItem: LocationItem) {
        (parentViewController! as! ViewController).showLocation(locationItem)
    }

}
