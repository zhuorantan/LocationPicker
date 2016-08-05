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
    public var locationType: LocationPicker.LocationType!
    
    public let iconView = UIImageView()
    public let locationNameLabel = UILabel()
    public let locationAddressLabel = UILabel()
    public let containerView = UIView()
    
    public convenience init(locationType: LocationPicker.LocationType, locationItem: LocationItem?) {
        self.init()
        self.locationType = locationType
        self.locationItem = locationItem
        
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        let length = contentView.bounds.height
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        separatorInset.left = length
        
        iconView.frame = CGRect(x: 0, y: 0, width: length, height: length)
        
        if let locationItem = locationItem {
            locationNameLabel.font = UIFont.systemFont(ofSize: 16)
            locationNameLabel.text = locationItem.name
            
            locationAddressLabel.font = UIFont.systemFont(ofSize: 11)
            locationAddressLabel.text = locationItem.formattedAddressString
        }
        
        contentView.addSubview(iconView)
        containerView.addSubview(locationNameLabel)
        if locationType! != .currentLocation {
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
            
            containerView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
            containerView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor).isActive = true
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
            
            locationNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            locationNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            if locationType! == .currentLocation {
                locationNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            } else {
                locationNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
                
                locationAddressLabel.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor).isActive = true
                locationAddressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                locationAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                locationAddressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            }
        } else {
            NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: iconView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: locationNameLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: locationNameLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            
            if locationType! == .currentLocation {
                NSLayoutConstraint(item: locationNameLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            } else {
                NSLayoutConstraint(item: locationNameLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
                
                NSLayoutConstraint(item: locationAddressLabel, attribute: .top, relatedBy: .equal, toItem: locationNameLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: locationAddressLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: locationAddressLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: locationAddressLabel, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            }
        }
        
    }

}
