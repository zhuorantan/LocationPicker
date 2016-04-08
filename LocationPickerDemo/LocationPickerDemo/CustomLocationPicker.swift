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
        super.addButtons() // Handle over the button to LocationPicker and let it do the rest.
        super.viewDidLoad()
    }
    
    override func locationDidSelect(locationItem: LocationItem) {
        print("Select overrided method: " + locationItem.name)
    }
    
    override func locationDidPick(locationItem: LocationItem) {
        viewController.showLocation(locationItem)
        viewController.storeLocation(locationItem)
    }

}
