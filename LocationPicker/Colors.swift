//
//  Colors.swift
//  LocationPicker
//
//  Created by Joni Van Roost on 19/01/2020.
//  Copyright © 2020 Jerome Tan. All rights reserved.
//
// Credit to neoneye (https://github.com/neoneye) - SwiftyFORM

import UIKit

struct Colors {

    @DynamicUIColor(light: .white, dark: .black)
    static var background: UIColor

    @DynamicUIColor(light: .black, dark: .white)
    static var text: UIColor

    @DynamicUIColor(light: .gray, dark: .lightGray)
    static var secondaryText: UIColor

    @DynamicUIColor(light: UIColor(white: 0.9, alpha: 1), dark: .black)
    static var mutedBackground: UIColor

}
