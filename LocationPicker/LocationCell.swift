//
//  LocationCell.swift
//  LocationPicker
//
//  Created by Jerome Tan on 4/2/16.
//  Copyright © 2016 Jerome Tan. All rights reserved.
//

import UIKit

public enum LocationType {
    case CurrentLocation
    case SearchLocation
    case AlternativeLocation
}

public class LocationCell: UITableViewCell {
    
    public var locationItem: LocationItem?
    public var locationType: LocationType!
    
    public let iconView = UIImageView()
    public let locationNameLabel = UILabel()
    public let locationAddressLabel = UILabel()
    public let containerView = UIView()
    
    public convenience init(locationType: LocationType, locationItem: LocationItem?) {
        self.init()
        self.locationType = locationType
        self.locationItem = locationItem
        
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        let length = contentView.bounds.height
        
        backgroundColor = UIColor.clearColor()
        separatorInset.left = length
        
        iconView.frame = CGRect(x: 0, y: 0, width: length, height: length)
        
        if let locationItem = locationItem {
            locationNameLabel.font = UIFont.systemFontOfSize(16)
            locationNameLabel.text = locationItem.name
            
            locationAddressLabel.font = UIFont.systemFontOfSize(11)
            locationAddressLabel.text = locationItem.formattedAddressString
        }
        
        contentView.addSubview(iconView)
        containerView.addSubview(locationNameLabel)
        if locationType! != .CurrentLocation {
            containerView.addSubview(locationAddressLabel)
        }
        contentView.addSubview(containerView)
    }
    
    private func layoutViews() {
        locationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = contentView.layoutMarginsGuide
        
        containerView.centerYAnchor.constraintEqualToAnchor(margins.centerYAnchor).active = true
        containerView.leadingAnchor.constraintEqualToAnchor(iconView.trailingAnchor).active = true
        containerView.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        
        locationNameLabel.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor).active = true
        locationNameLabel.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor).active = true
        if locationType! == .CurrentLocation {
            locationNameLabel.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
            
        } else {
            locationNameLabel.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
            
            locationAddressLabel.topAnchor.constraintEqualToAnchor(locationNameLabel.bottomAnchor).active = true
            locationAddressLabel.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor).active = true
            locationAddressLabel.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor).active = true
            locationAddressLabel.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor).active = true
        }
    }

}
