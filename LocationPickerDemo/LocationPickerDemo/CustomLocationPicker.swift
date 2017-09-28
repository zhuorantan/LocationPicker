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
    
    var viewController: ViewController!

    override func viewDidLoad() {
        super.addBarButtons()
        super.viewDidLoad()
    }
    
    @objc override func locationDidSelect(locationItem: LocationItem) {
        print("Select overrided method: " + locationItem.name)
    }
    
    @objc override func locationDidPick(locationItem: LocationItem) {
        viewController.showLocation(locationItem: locationItem)
        viewController.storeLocation(locationItem: locationItem)
    }
}
