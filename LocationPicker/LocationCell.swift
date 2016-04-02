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
    
    var locationItem: LocationItem?
    var locationType: LocationType!
    
    private let iconView = UIImageView()
    private let locationNameLabel = UILabel()
    private let locationAddressLabel = UILabel()
    private let containerView = UIView()
    
    private var iconColor: UIColor!
    
    convenience init(locationType: LocationType, locationItem: LocationItem? = nil, title: String? = nil, iconColor: UIColor, iconImage: UIImage?) {
        self.init()
        self.locationType = locationType
        self.locationItem = locationItem
        self.iconColor = iconColor
        iconView.image = iconImage
        
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
        if iconView.image == nil {
            switch locationType! {
            case .CurrentLocation:
                iconView.image = StyleKit.imageOfMapPointerIcon(size: CGSize(width: length, height: length), color: iconColor)
            case .SearchLocation:
                iconView.image = StyleKit.imageOfSearchIcon(size: CGSize(width: length, height: length), color: iconColor)
            case .HistoryLocation:
                iconView.image = StyleKit.imageOfPinIcon(size: CGSize(width: length, height: length), color: iconColor)
            }
        }
        
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
