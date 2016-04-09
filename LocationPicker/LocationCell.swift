//
//  LocationCell.swift
//  LocationPicker
//
//  Created by Jerome Tan on 4/2/16.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Jerome Tan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

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
        
        if #available(iOS 9.0, *) {
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
        } else {
            NSLayoutConstraint(item: containerView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: iconView, attribute: .Trailing, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1, constant: 0).active = true
            
            NSLayoutConstraint(item: locationNameLabel, attribute: .Leading, relatedBy: .Equal, toItem: containerView, attribute: .Leading, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: locationNameLabel, attribute: .Trailing, relatedBy: .Equal, toItem: containerView, attribute: .Trailing, multiplier: 1, constant: 0).active = true
            
            if locationType! == .CurrentLocation {
                NSLayoutConstraint(item: locationNameLabel, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1, constant: 0).active = true
            } else {
                NSLayoutConstraint(item: locationNameLabel, attribute: .Top, relatedBy: .Equal, toItem: containerView, attribute: .Top, multiplier: 1, constant: 0).active = true
                
                NSLayoutConstraint(item: locationAddressLabel, attribute: .Top, relatedBy: .Equal, toItem: locationNameLabel, attribute: .Bottom, multiplier: 1, constant: 0).active = true
                NSLayoutConstraint(item: locationAddressLabel, attribute: .Leading, relatedBy: .Equal, toItem: containerView, attribute: .Leading, multiplier: 1, constant: 0).active = true
                NSLayoutConstraint(item: locationAddressLabel, attribute: .Trailing, relatedBy: .Equal, toItem: containerView, attribute: .Trailing, multiplier: 1, constant: 0).active = true
                NSLayoutConstraint(item: locationAddressLabel, attribute: .Bottom, relatedBy: .Equal, toItem: containerView, attribute: .Bottom, multiplier: 1, constant: 0).active = true
            }
        }
        
    }

}
