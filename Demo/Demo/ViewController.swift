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
    
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var locationAddressTextField: UITextField!
    
    var locationList = [LocationItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        locationNameTextField.text = nil
        locationAddressTextField.text = nil
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LocationPicker" {
            let customLocationPicker = segue.destinationViewController as! LocationPicker
            customLocationPicker.delegate = self
            customLocationPicker.historyLocationEditable = true
            customLocationPicker.historyLocationList = locationList
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
        locationNameTextField.text = locationItem.name
        locationAddressTextField.text = locationItem.formattedAddressString
    }
    
    
    
    func locationDidSelect(locationItem: LocationItem) {
        locationList.append(locationItem)
        print(locationItem)
    }
    
    func locationDidPick(locationItem: LocationItem) {
        showLocation(locationItem)
    }

}
