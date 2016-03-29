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
}

public class LocationPicker: UIViewController {
    
    public var completion: ((MKMapItem) -> Void)?
    public var delegate: LocationPickerDelegate?
    
    
    
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
