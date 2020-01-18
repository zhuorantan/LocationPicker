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
    @IBOutlet weak var arbitraryLocationSwitch: UISwitch!
    
    var historyLocationList: [LocationItem] {
        get {
            if let locationDataList = UserDefaults.standard.array(forKey: "HistoryLocationList") as? [Data] {
                // Decode NSData into LocationItem object.
                return locationDataList.map({ NSKeyedUnarchiver.unarchiveObject(with: $0) as! LocationItem })
            } else {
                return []
            }
        }
        set {
            // Encode LocationItem object.
            let locationDataList = newValue.map({ NSKeyedArchiver.archivedData(withRootObject: $0) })
            UserDefaults.standard.set(locationDataList, forKey: "HistoryLocationList")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationNameTextField.text = nil
        locationAddressTextField.text = nil
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Show Location Picker via push segue.
        // LocationPicker in Storyboard.
        if segue.identifier == "LocationPicker" {
            let locationPicker = segue.destination as! LocationPicker
            // User delegate and dataSource.
            locationPicker.delegate = self
            locationPicker.dataSource = self
            locationPicker.isAlternativeLocationEditable = true
            locationPicker.isAllowArbitraryLocation = arbitraryLocationSwitch.isOn
        }
    }
    
    
    
    @IBAction func presentLocationPickerButtonDidTap(button: UIButton) {
        // Present Location Picker subclass via codes.
        // Create LocationPicker subclass.
        let customLocationPicker = CustomLocationPicker()
        customLocationPicker.isAllowArbitraryLocation = arbitraryLocationSwitch.isOn
        customLocationPicker.viewController = self
        let navigationController = UINavigationController(rootViewController: customLocationPicker)
        present(navigationController, animated: true, completion: nil)
    }
    
    // Push LocationPicker to navigation controller.
    @IBAction func pushLocationPickerButtonDidTap(button: UIButton) {
        // Push Location Picker via codes.
        let locationPicker = LocationPicker()
        locationPicker.alternativeLocations = historyLocationList.reversed()
        locationPicker.isAlternativeLocationEditable = true
        locationPicker.preselectedIndex = 0
        locationPicker.isAllowArbitraryLocation = arbitraryLocationSwitch.isOn
        
        // Completion closures
        locationPicker.selectCompletion = { selectedLocationItem in
            print("Select completion closure: " + selectedLocationItem.name)
        }
        locationPicker.pickCompletion = { pickedLocationItem in
            self.showLocation(locationItem: pickedLocationItem)
            self.storeLocation(locationItem: pickedLocationItem)
        }
        locationPicker.deleteCompletion = { locationItem in
            self.historyLocationList.remove(at: self.historyLocationList.firstIndex(of: locationItem)!)
        }
        navigationController!.pushViewController(locationPicker, animated: true)
    }
    
    
    
    // Location Picker Delegate
    
    func locationDidSelect(locationItem: LocationItem) {
        print("Select delegate method: " + locationItem.name)
    }
    
    func locationDidPick(locationItem: LocationItem) {
        showLocation(locationItem: locationItem)
        storeLocation(locationItem: locationItem)
    }
    
    
    
    // Location Picker Data Source
    
    func numberOfAlternativeLocations() -> Int {
        return historyLocationList.count
    }
    
    func alternativeLocation(at index: Int) -> LocationItem {
        return historyLocationList.reversed()[index]
    }
    
    func commitAlternativeLocationDeletion(locationItem: LocationItem) {
        historyLocationList.remove(at: historyLocationList.firstIndex(of: locationItem)!)
    }
    
    
    
    func showLocation(locationItem: LocationItem) {
        locationNameTextField.text = locationItem.name
        locationAddressTextField.text = locationItem.formattedAddressString
    }
    
    func storeLocation(locationItem: LocationItem) {
        if let index = historyLocationList.firstIndex(of: locationItem) {
            historyLocationList.remove(at: index)
        }
        historyLocationList.append(locationItem)
    }

}
