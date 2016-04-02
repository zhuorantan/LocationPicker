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
    
    var historyLocationList = [LocationItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locationDataList = NSUserDefaults.standardUserDefaults().arrayForKey("HistoryLocationList") as? [NSData] {
            self.historyLocationList = locationDataList.map({ NSKeyedUnarchiver.unarchiveObjectWithData($0) as! LocationItem })
        }
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
            customLocationPicker.historyLocationEditable = true
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
        locationPicker.historyLocationList = historyLocationList.reverse()
        locationPicker.historyLocationEditable = true
        
        locationPicker.selectCompletion = { selectedLocationItem in
            
        }
        locationPicker.pickCompletion = { pickedLocationItem in
            self.showLocation(pickedLocationItem)
            self.storeLocation(pickedLocationItem)
        }
        locationPicker.deleteCompletion = { locationItem in
            self.deleteLocation(locationItem)
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
    
    func numberOfHistoryLocations() -> Int {
        return historyLocationList.count
    }
    
    func historyLocationAtIndex(index: Int) -> LocationItem {
        return historyLocationList.reverse()[index]
    }
    
    func commitHistoryLocationDeletion(locationItem: LocationItem) {
        deleteLocation(locationItem)
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
        let locationDataList = historyLocationList.map({ NSKeyedArchiver.archivedDataWithRootObject($0) })
        NSUserDefaults.standardUserDefaults().setObject(locationDataList, forKey: "HistoryLocationList")
    }
    
    func deleteLocation(locationItem: LocationItem) {
        historyLocationList.removeAtIndex(historyLocationList.indexOf(locationItem)!)
        let locationDataList = historyLocationList.map({ NSKeyedArchiver.archivedDataWithRootObject($0) })
        NSUserDefaults.standardUserDefaults().setObject(locationDataList, forKey: "HistoryLocationList")
    }

}
