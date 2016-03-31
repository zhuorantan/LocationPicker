//
//  ViewController.swift
//  LocationPickerExample
//
//  Created by Jerome Tan on 3/29/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import LocationPicker

class ViewController: UIViewController, LocationPickerDelegate {
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LocationPicker" {
            let customLocationPicker = segue.destinationViewController as! LocationPicker
            customLocationPicker.delegate = self
        }
    }
    
    
    
    @IBAction func presentLocationPickerButtonDidTap(sender: UIButton) {
        let locationPicker = CustomLocationPicker()
        locationPicker.viewController = self
        let navigationController = UINavigationController(rootViewController: locationPicker)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func pushLocationPickerButtonDidTap(sender: UIButton) {
        let locationPicker = LocationPicker()
        
        locationPicker.selectCompletion = { selectedLocationItem in
            
        }
        locationPicker.pickCompletion = { pickedLocationItem in
            self.showLocation(pickedLocationItem)
        }
        navigationController!.pushViewController(locationPicker, animated: true)
    }
    
    
    
    func showLocation(locationItem: LocationItem) {
        locationNameLabel.text = locationItem.name
        locationAddressLabel.text = (locationItem.addressDictionary!["FormattedAddressLines"] as! [String])[0]
    }
    
    
    
    func locationDidPick(locationItem: LocationItem) {
        showLocation(locationItem)
    }

}
