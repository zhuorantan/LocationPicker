//
//  LocationCell.swift
//  LocationPicker
//
//  Created by Jerome Tan on 4/2/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit

enum LocationType {
    case CurrentLocation
    case SearchLocation
    case HistoryLocation
}

class LocationCell: UITableViewCell {
    
    public var locationItem: LocationItem?
    public var locationType: LocationType!
    
    private let iconView = UIImageView()
    private let locationNameLabel = UILabel()
    
    convenience init(locationType: LocationType, locationItem: LocationItem? = nil, title: String? = nil) {
        self.init()
        self.locationType = locationType
        self.locationItem = locationItem
        
        if let title = title {
            locationNameLabel.text = title
        }
        
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        let length = contentView.bounds.height
        
        separatorInset.left = length
        
        iconView.frame = CGRect(x: 0, y: 0, width: length, height: length)
        switch locationType! {
        case .CurrentLocation:
            iconView.image = StyleKit.imageOfMapPointerIcon(size: CGSize(width: length, height: length))
        case .SearchLocation:
            iconView.image = StyleKit.imageOfSearchIcon(size: CGSize(width: length, height: length))
        case .HistoryLocation:
            iconView.image = StyleKit.imageOfPinIcon(size: CGSize(width: length, height: length))
        }
        
        if let locationItem = locationItem {
            locationNameLabel.text = locationItem.name
        }
        
        contentView.addSubview(iconView)
        contentView.addSubview(locationNameLabel)
    }
    
    private func layoutViews() {
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = contentView.layoutMarginsGuide
        
        locationNameLabel.centerYAnchor.constraintEqualToAnchor(margins.centerYAnchor).active = true
        locationNameLabel.leadingAnchor.constraintEqualToAnchor(iconView.trailingAnchor).active = true
    }

}
