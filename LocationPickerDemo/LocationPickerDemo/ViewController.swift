//
//  ViewController.swift
//  LocationPickerExample
//
//  Created by Jerome Tan on 3/29/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import LocationPicker

class ViewController: UIViewController, LocationPickerDelegate, LocationPickerDataSource {
    
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var locationAddressTextField: UITextField!

    var historyLocationList: [LocationItem] {
        get {
            if let locationDataList = NSUserDefaults.standardUserDefaults().arrayForKey("HistoryLocationList") as? [NSData] {
                // Decode NSData into LocationItem object.
                return locationDataList.map({ NSKeyedUnarchiver.unarchiveObjectWithData($0) as! LocationItem })
            } else {
                return []
            }
        }
        set {
            // Encode LocationItem object.
            let locationDataList = newValue.map({ NSKeyedArchiver.archivedDataWithRootObject($0) })
            NSUserDefaults.standardUserDefaults().setObject(locationDataList, forKey: "HistoryLocationList")
        }
    }
    
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
        // Show Location Picker via push segue.
        // LocationPicker in Storyboard.
        if segue.identifier == "LocationPicker" {
            let locationPicker = segue.destinationViewController as! LocationPicker
            // User delegate and dataSource.
            locationPicker.delegate = self
            locationPicker.dataSource = self
            locationPicker.alternativeLocationEditable = true
        }
    }
    
    
    
    @IBAction func presentLocationPickerButtonDidTap(sender: UIButton) {
        // Present Location Picker subclass via codes.
        // Create LocationPicker subclass.
        let customLocationPicker = CustomLocationPicker()
        customLocationPicker.viewController = self
        let navigationController = UINavigationController(rootViewController: customLocationPicker)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // Push LocationPicker to navigation controller.
    @IBAction func pushLocationPickerButtonDidTap(sender: UIButton) {
        // Push Location Picker via codes.
        let locationPicker = LocationPicker()
        locationPicker.alternativeLocations = historyLocationList.reverse()
        locationPicker.alternativeLocationEditable = true
        
        // Completion closures
        locationPicker.selectCompletion = { selectedLocationItem in
            print("Select completion closure: " + selectedLocationItem.name)
        }
        locationPicker.pickCompletion = { pickedLocationItem in
            self.showLocation(pickedLocationItem)
            self.storeLocation(pickedLocationItem)
        }
        locationPicker.deleteCompletion = { locationItem in
            self.historyLocationList.removeAtIndex(self.historyLocationList.indexOf(locationItem)!)
        }
        navigationController!.pushViewController(locationPicker, animated: true)
    }
    
    
    
    // Location Picker Delegate
    
    func locationDidSelect(locationItem: LocationItem) {
        print("Select delegate method: " + locationItem.name)
    }
    
    func locationDidPick(locationItem: LocationItem) {
        showLocation(locationItem)
        storeLocation(locationItem)
    }
    
    
    
    // Location Picker Data Source
    
    func numberOfAlternativeLocations() -> Int {
        return historyLocationList.count
    }
    
    func alternativeLocationAtIndex(index: Int) -> LocationItem {
        return historyLocationList.reverse()[index]
    }
    
    func commitAlternativeLocationDeletion(locationItem: LocationItem) {
        historyLocationList.removeAtIndex(historyLocationList.indexOf(locationItem)!)
    }
    
    
    
    func showLocation(locationItem: LocationItem) {
        locationNameTextField.text = locationItem.name
        locationAddressTextField.text = locationItem.formattedAddressString
    }
    
    func storeLocation(locationItem: LocationItem) {
        if let index = historyLocationList.indexOf(locationItem) {
            historyLocationList.removeAtIndex(index)
        }
        historyLocationList.append(locationItem)
    }

}
