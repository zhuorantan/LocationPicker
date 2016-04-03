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
                return locationDataList.map({ NSKeyedUnarchiver.unarchiveObjectWithData($0) as! LocationItem })
            } else {
                return []
            }
        }
        set {
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
        if segue.identifier == "LocationPicker" {
            let customLocationPicker = segue.destinationViewController as! LocationPicker
            customLocationPicker.delegate = self
            customLocationPicker.dataSource = self
            customLocationPicker.alternativeLocationEditable = true
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
        locationPicker.alternativeLocations = historyLocationList.reverse()
        locationPicker.alternativeLocationEditable = true
        
        locationPicker.selectCompletion = { selectedLocationItem in
            
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
    
    func commitHistoryLocationDeletion(locationItem: LocationItem) {
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
