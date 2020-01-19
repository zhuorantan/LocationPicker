//
//  DynamicUIColor.swift
//  LocationPicker
//
//  Created by Joni Van Roost on 19/01/2020.
//  Copyright © 2020 Jerome Tan. All rights reserved.
//
// Credit to neoneye (https://github.com/neoneye) - SwiftyFORM

import Foundation

import UIKit

@propertyWrapper
public struct DynamicUIColor {

    /// Backwards compatible wrapper arround UIUserInterfaceStyle
    public enum Style {
        case light, dark
    }

    let light: UIColor
    let dark: UIColor
    let styleProvider: () -> Style?

    public init(
        light: UIColor,
        dark: UIColor,
        style: @autoclosure @escaping () -> Style? = nil
    ) {
        self.light = light
        self.dark = dark
        self.styleProvider = style
    }

    public var wrappedValue: UIColor {
        switch styleProvider() {
        case .dark: return dark
        case .light: return light
        case .none:
            if #available(iOS 13.0, tvOS 13.0, *) {
                return UIColor { traitCollection -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                    case .dark: return self.dark
                    case .light, .unspecified: return self.light
                    @unknown default: return self.light
                    }
                }
            } else {
                return light
            }
        }
    }
}
