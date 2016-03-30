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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func presentLocationPickerButtonDidTap(sender: UIButton) {
        let locationPicker = LocationPicker()
        locationPicker.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(dismissLocationPicker(_:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(dismissLocationPicker(_:)))
        doneButton.enabled = false
        locationPicker.doneButtonItem = doneButton
        locationPicker.navigationItem.rightBarButtonItem = doneButton
        
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
        
    }
    
    func dismissLocationPicker(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func locationDidPick(locationItem: LocationItem) {
        showLocation(locationItem)
    }

}
