//
//  ViewController.swift
//  LocationPickerExample
//
//  Created by Jerome Tan on 3/29/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import MapKit
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
        
        locationPicker.selectCompletion = { selectedMapItem in
            
        }
        locationPicker.pickCompletion = { pickedMapItem in
            self.showLocation(pickedMapItem)
        }
        navigationController!.pushViewController(locationPicker, animated: true)
    }
    
    
    func showLocation(mapItem: MKMapItem) {
        
    }
    
    func dismissLocationPicker(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func locationDidPick(mapItem: MKMapItem) {
        showLocation(mapItem)
    }

}
