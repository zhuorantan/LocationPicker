# LocationPicker

A ready for use and fully customizable location picker for your app.

![](/Screenshots/locationpicker.gif)

![Language](https://img.shields.io/badge/language-Swift%202.2-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/JTLocationPicker.svg?style=flat)](http://cocoadocs.org/docsets/JTLocationPicker/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License](https://img.shields.io/github/license/JeromeTan1997/LocationPicker.svg?style=flat)

* [Features](#features)
* [Installation](#installation)
    - [Cocoapods](#cocoapods)
    - [Carthage](#carthage)
* [Quick Start](#quick-start)
    - [Programmatically](#programmatically)
    - [Storyboard](#storyboard)

## Features
* Easy to use - A fully functional location picker can be integrated to your app within __5 lines__ of codes.
* Comprehensive - `LocationPicker` provides __Completion Closure__, __Delegate__, __Overriding__ to suit your need.
* Fully customizable - `LocationPicker` equips with many customization attributes and methods. Original UI elements like `SearchBar`, `UITableView`, `MKMapItem` are accessible if you want to do some deep customization.

## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate `LocationPicker` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'YourApp' do
    pod 'JTLocationPicker'
end
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Permission into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "JeromeTan1997/LocationPicker"
```

## Quick Start

### Programmatically

Showing `LocationPicker` via navigation controller is very simple, just create one, add a completion closure and push it.
```swift
let locationPicker = LocationPicker()
locationPicker.pickCompletion = { (pickedLocationItem) in
    // Do something with the location the user picked.
}
navigationController!.pushViewController(locationPicker, animated: true)
```

To present `LocationPicker`, it needs to be nested inside a navigation controller so that it can be dismissed.
```swift
let locationPicker = LocationPicker()
locationPicker.pickCompletion = { (pickedLocationItem) in
    // Do something with the location the user picked.
}
locationPicker.addButtons()
// Call this method to add a done and a cancel button to navigation bar.

let navigationController = UINavigationController(rootViewController: customLocationPicker)
presentViewController(navigationController, animated: true, completion: nil)
```

### Storyboard

1. Drag a __View Controller__ to your Storyboard.
2. In the __Identity inspector__, Entry `LocationPicker` both in __Class__ and __Module__ field.
![](/Screenshots/storyboard.png)
3. Create a __segue__ and add a __Identifier__ to it.
4. Add the following codes in the source view controller.
```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "LocationPicker" {
        let locationPicker = segue.destinationViewController as! LocationPicker
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
        }
    }
}
```

That's __all__ you need to have a fully functional location picker in your app. How easy!
