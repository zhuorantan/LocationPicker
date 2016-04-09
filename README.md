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
* [Customization](#customization)
    - [Methods](#methods)
    - [Boolean](#boolean)
    - [Text](#text)
    - [Color](#color)
    - [Image](#image)
    - [Other](#other)
* [Callback](#callback)
    - [Closure](#closure)
    - [Delegate and Data Source](#delegate-and-data-source)
    - [Override](#override)

## Features
* Easy to use - A fully functional location picker can be integrated to your app within __5 lines__ of codes. `LocationPicker` can be subclassed both in storyboard and programmatically.
* Comprehensive - `LocationPicker` provides __Completion Closure__, __Delegate and Data Source__, __Override__ to suit your need.
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
    if segue.identifier == "Your Identifier" {
        let locationPicker = segue.destinationViewController as! LocationPicker
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
        }
    }
}
```

That's __all__ you need to have a fully functional location picker in your app. How easy!

## Customization

### Methods

##### `func addButtons`

This method provides 3 optional parameter. `doneButtonItem` and `cancelButtonItem` can be set as the customized `UIBarButtonItem` object. `doneButtonOrientation` is used to determine how to align these two buttons. If none of the parameters is provided, two system style buttons would be used, and the done button would be put on the right side.

##### `func setColors`

This method aims to set colors more conveniently. `themColor` will be set to `currentLocationIconColor`, `searchResultLocationIconColor`, `alternativeLocationIconColor`, `pinColor`. `primaryTextColor` and `secondaryTextColor` can also be set by this method.

##### `func customizeLocationDeniedAlertController`

This method provides the texts of `locationDeniedAlertController` simultaneously.

### Boolean

| Property name | Default | Target | Remark |
| ------------- |:-------:| ------ | ------ |
| mapViewZoomEnabled | true | mapView.zoomEnabled | Whether the map view can zoom in and out |
| mapViewShowsUserLocation | true | mapView.showsUserLocation | Whether the map view shows user's location |
| mapViewScrollEnabled | true | mapView.scrollEnabled | Whether user can scroll the map view |
| alternativeLocationEditable | false | tableViewDataSource.tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) | Whether user can delete the provided locations in table view |

__Note__: If `alternativeLocationEditable` is set to true, please adopt __Location Deletion__ callback to delete the location from database or memory.

### Text

| Property name | Default | Target | Remark |
| ------------- |:-------:| ------ | ------ |
| currentLocationText | "Current Location" | currentLocationCell.locationNameLabel.text | The text that indicates the user's current location |
| searchBarPlaceholder | "Search for location" | searchBar.placeholder | The text that ask user to search for locations |
| locationDeniedAlertTitle | "No location access" | alertController.title | The text of the alert controller's title |
| locationDeniedAlertMessage | "Grant location access to use current location" | alertController.message | The text of the alert controller's message |
| locationDeniedGrantText | "Grant" | alertAction.title | The text of the alert controller's _Grant_ button |
| locationDeniedCancelText | "Cancel" | alertAction.title | The text of the alert controller's _Cancel_ button |

### Color

| Property name | Default | Target | Remark |
| ------------- |:-------:| ------ | ------ |
| tableViewBackgroundColor | UIColor.whiteColor() | tableView.backgroundColor | The background color of the table view |
| currentLocationIconColor | UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1) | UIImage() | The color of the icon showed in current location cell, the icon image can be changed via property `currentLocationIconImage` |
| searchResultLocationIconColor | UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1) | UIImage() | The color of the icon showed in search result location cells, the icon image can be changed via property `searchResultLocationIconImage` |
| alternativeLocationIconColor | UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1) | UIImage() | The color of the icon showed in alternative location cells, the icon image can be changed via property 'alternativeLocationIconImage' |
| pinColor | UIColor(hue: 0.447, saturation: 0.731, brightness: 0.569, alpha: 1) | UIImage() | The color of the pin showed in the center of map view, the pin image can be changed via property `pinImage` |
| primaryTextColor | UIColor(colorLiteralRed: 0.34902, green: 0.384314, blue: 0.427451, alpha: 1) | Multiple | The text color of search bar and location name label in location cells |
| secondaryTextColor | UIColor(colorLiteralRed: 0.541176, green: 0.568627, blue: 0.584314, alpha: 1) | Multiple | The text color of location address label in location cells |

### Image

| Property name | Target | Remark |
| ------------- | ------ | ------ |
| currentLocationIconImage | currentLocationCell.iconView.image | The image of the icon showed in current location cell, this image's color won't be affected by property `currentLocationIconColor` |
| searchResultLocationIconImage | searchResultLocationCell.iconView.image | The image of the icon showed in search result location cells, this image's color won't be affected by property `searchResultLocationIconColor` |
| alternativeLocationIconImage | alternativeLocationCell.iconView.image | The image of the icon showed in alternative location cells, this image's color won't be affected by property `alternativeLocationIconColor` |

### Other

| Property name | Type | Default | Remark |
| ------------- |:----:|:-------:| ------ |
| alternativeLocations | [LocationItem]? | nil | Locations that show under current location and search result locations |
| locationDeniedAlertController | UIAlertController? | nil | Alert controller that appear when user request current location but denied the app's location permission |
| defaultLongitudinalDistance | Double | 1000 | Longitudinal distance of the map view shows when user select a location and before zoom in or zoom out |
| searchDistance | Double | 10000 | Distance in meters that is used to search locations |

__Note__:
* Alternative locations can also be provided via [Data Source](#alternative-location-data-source).
* You don't need to set the `locationDeniedAlertController` if you are satisfied with the alert controller included in `LocationPicker`. You can change the texts of the default alert controller via `func customizeLocationDeniedAlertController`. If you want to do something other than presenting an alert controller, you can adopt __Permission Denied Handler__ callback.

## Callbacks

`LocationPicker` provides three different types of callbacks, they are __Closure__, __Delegate and Data Source__ and __Override__, you can choose whichever you like. In most cases, using closures is the most convenient way. If you are already subclassing `LocationPicker`, override may be the best choice.

### Closure

##### Location Pick

This completion closure is used to get user's final decision. It would be executed only once for every `LocationPicker` object when it is about to be dismissed.

```swift
locationPicker.pickCompletion = { (pickedLocationItem) in
    // Do something with the location the user picked.
}
```

##### Location Selection

This completion closure is used to get user's every location selection. It would be executed every time user chooses a location in the list or drag the map view.

```swift
locationPicker.selectCompletion = { (selectedLocationItem) in
    // Do something with user's every selection.
}
```

##### Location Deletion

If `alternativeLocations` is not empty and `alternativeLocationEditable` is set to `true`, this closure will be executed when user delete a location item in the table view.

```swift
locationPicker.deleteCompletion = { (deletedLocationItem) in
    // Delete the location.
}
```

##### Permission Denied Handler

In default, when user request current location but denied the app's location permission, `LocationPicker` will present an alert controller that links to the Settings. You can change the texts in the alert controller by calling `func customizeLocationDeniedAlertController`. If you need to do something other than presenting an alert controller, you can set this closure.

```swift
locationPicker.locationDeniedHandler = { (locationPicker) in
    // Ask user to grant location permission of this app.
}
```

<!-- ### Delegate and Data Source

1. Conform to `LocationPickerDelegate`
```swift
class YourViewController: LocationPickerDelegate
```
2. Set `delegate` to this class
```swift
locationPicker.delegate = self
```
3. Implement `func locationDidPick(locationItem: LocationItem)`
```swift
func locationDidPick(locationItem: LocationItem) {
    // Do something with the location the user picked.
}
```

### Override -->
