//
//  LocationPicker.swift
//  LocationPicker
//
//  Created by Jerome Tan on 3/28/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit
import MapKit

@objc public protocol LocationPickerDelegate {
    optional func locationDidSelect(mapItem: MKMapItem)
    optional func historyLocationAtIndex(index: Int) -> MKMapItem
    optional func deleteHistoryLocation(mapItem: MKMapItem, AtIndex index: Int)
}



public class LocationPicker: UIViewController {
    
    public var completion: ((MKMapItem) -> Void)?
    public var delegate: LocationPickerDelegate?
    public var historyLocationList: [MKMapItem]?
    
    
    
    // Configurations
    
    public var mapViewDraggable = true
    public var historyLocationEditable = true
    
    public var currentLocationColor = UIColor.blackColor()
    public var searchResultLocationColor = UIColor.blackColor()
    public var historyLocationColor = UIColor.blackColor()
    public var pinColor = UIColor.blackColor()
    
    public var currentLocationImage = UIImage()
    public var searchResultLocationImage = UIImage()
    public var historyLocationImage = UIImage()
    
    
    
    private var selectedMapItem: MKMapItem?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()

    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        layoutViews()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let mapItem = selectedMapItem {
            completion?(mapItem)
            delegate?.locationDidSelect?(mapItem)
        }
    }
    
    
    
    public func setThemeColor(color: UIColor) {
        currentLocationColor = color
        searchResultLocationColor = color
        historyLocationColor = color
        pinColor = color
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    private func layoutViews() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        searchBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        searchBar.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: -view.layoutMargins.left * 2).active = true
        searchBar.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor, constant: view.layoutMargins.right * 2).active = true
        
        tableView.topAnchor.constraintEqualToAnchor(searchBar.bottomAnchor).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(searchBar.leadingAnchor).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(searchBar.trailingAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
    }
    
}
