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
    
    private var iconView: IconView!
    private let locationNameLabel = UILabel()
    
    convenience init(locationType: LocationType, locationItem: LocationItem?) {
        self.init()
        self.locationType = locationType
        self.locationItem = locationItem
        
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        let length = contentView.bounds.height
        iconView = IconView(frame: CGRect(x: 0, y: 0, width: length, height: length), locationType: locationType)
        iconView.backgroundColor = UIColor.clearColor()
        
        locationNameLabel.text = locationItem?.name
        
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

class IconView: UIView {
    
    private var locationType: LocationType!
    
    convenience init(frame: CGRect, locationType: LocationType) {
        self.init(frame: frame)
        self.locationType = locationType
    }
    
    override func drawRect(rect: CGRect) {
        switch locationType! {
        case .CurrentLocation:
            StyleKit.drawMapPointerIcon()
        case .SearchLocation:
            StyleKit.drawSearchIcon()
        case .HistoryLocation:
            StyleKit.drawPinIcon()
        }
        
    }
}
