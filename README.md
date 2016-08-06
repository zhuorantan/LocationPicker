# LocationPicker

A ready for use and fully customizable location picker for your app.

![](https://raw.githubusercontent.com/JeromeTan1997/LocationPicker/master/Screenshots/locationpicker.gif)

![Language](https://img.shields.io/badge/language-Swift%202.2-orange.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/LocationPickerViewController.svg?style=flat)](http://cocoadocs.org/docsets/LocationPickerViewController/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![License](https://img.shields.io/github/license/JeromeTan1997/LocationPicker.svg?style=flat)

* [Features](#features)
* [Installation](#installation)
    - [Cocoapods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
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
* [Location Item](#location-item)
    - [Storage](#storage)
    - [Equatable](#equatable)
    - [Properties](#properties)
    - [Initialization](#initialization)
* [Change Log](#change-log)
* [Contribute](#contribute)
* [License](#license)

## Features
* Easy to use - A fully functional location picker can be integrated to your app within __5 lines__ of codes. `LocationPicker` can be subclassed in storyboard or programmatically.
* Comprehensive - `LocationPicker` provides [Closure](#closure), [Delegate and Data Source](#delegate-and-data-source), [Override](#override) for callback to suit your need.
* All kinds of locations to pick - Users can pick locations from their current location, search results or a list of locations provided by your app.
* Fully customizable - `LocationPicker` provides a great deal of customizability allowing all text to be customized along with the colors and icons. Original UI elements like `UISearchBar`, `UITableView`, `MKMapItem` are also accessible if you want to do some deep customization.
* Permission worry free - `LocationPicker` requests location access for you.

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
    pod 'LocationPickerViewController'
end
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `LocationPicker` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "JeromeTan1997/LocationPicker"
```

### Swift Package Manager

[Swift Package Manager](#https://swift.org/package-manager/) is a tool for managing the distribution of Swift code.

Swift Package Manager is currently only available with the Swift 3 development [snapshots](#https://swift.org/download/).

To integrate `LocationPicker` into your Xcode project using Swift Package Manager, specify it in your `Packages.swift`:

```swift
import PackageDescription

let package = Package(
    name: "Your Project Name",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/JeromeTan1997/LocationPicker.git", versions: "2.0.0" ..< Version.max)
    ]
)
```

## Quick Start

### Programmatically

Import `LocationPicker`

```swift
import LocationPicker
```

__NOTE__: If you installed via Cocoapods:

```swift
import LocationPickerViewController
```

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
![](https://raw.githubusercontent.com/JeromeTan1997/LocationPicker/master/Screenshots/storyboard.png)
__NOTE__: If you installed via Cocopods, the __Module__ field should be `LocationPickerViewController`
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

__Note__: To use current location, don't forget to add `NSLocationWhenInUseUsageDescription` to your `info.plist`

## Customization

### Methods

##### `func addButtons`

This method provides 3 optional parameter. `doneButtonItem` and `cancelButtonItem` can be set as the customized `UIBarButtonItem` object. `doneButtonOrientation` is used to determine how to align these two buttons. If none of the parameters is provided, two system style buttons would be used, and the done button would be put on the right side.

After this method is called, these two buttons can be accessed via `barButtonItems` property.

##### `func setColors`

This method aims to set colors more conveniently. `themColor` will be set to `currentLocationIconColor`, `searchResultLocationIconColor`, `alternativeLocationIconColor`, `pinColor`. `primaryTextColor` and `secondaryTextColor` can also be set by this method.

##### `func setLocationDeniedAlertControllerTitle`

This method provides the text of `locationDeniedAlertController` simultaneously.

If this method is not called, the alert controller will be presented like this

![](https://raw.githubusercontent.com/JeromeTan1997/LocationPicker/master/Screenshots/location-access.png)

__Grant__ button will direct user to the Settings where location access can be changed.

### Boolean

| Property name | Default | Target | Remark |
| ------------- |:-------:| ------ | ------ |
| allowArbitraryLocation | false | | Allows the selection of locations that did not match or exactly match search results |
| mapViewZoomEnabled | true | mapView.zoomEnabled | Whether the map view can zoom in and out |
| mapViewShowsUserLocation | true | mapView.showsUserLocation | Whether the map view shows user's location |
| mapViewScrollEnabled | true | mapView.scrollEnabled | Whether user can scroll the map view |
| isRedirectToExactCoordinate | true | | Whether redirect to the exact coordinate after queried |
| alternativeLocationEditable | false | tableViewDataSource.tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) | Whether user can delete the provided locations in table view |
| forceReverseGeocoding | false | | Whether to force reverse geocoding or not. If this property is set to `true`, the location will be reverse geocoded |

__Note__: If `alternativeLocationEditable` is set to true, please adopt __Location Deletion__ callback to delete the location from database or memory.

### Text

| Property name | Default | Target | Remark |
| ------------- |:-------:| ------ | ------ |
| currentLocationText | "Current Location" | currentLocationCell.locationNameLabel.text | The text that indicates the user's current location |
| searchBarPlaceholder | "Search for location" | searchBar.placeholder | The text that ask user to search for locations |
| locationDeniedAlertTitle | "Location access denied" | alertController.title | The text of the alert controller's title |
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
* Alternative locations can also be provided via __Data Source__.
* You don't need to set the `locationDeniedAlertController` if you are satisfied with the alert controller included in `LocationPicker`. You can change the text of the default alert controller via `func setLocationDeniedAlertControllerTitle`. If you want to do something other than presenting an alert controller, you can adopt __Permission Denied Handler__ callback.

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

By default, when user request current location but denied the app's location access, `LocationPicker` will present an alert controller that links to the Settings. You can change the text in the alert controller by calling `func setLocationDeniedAlertControllerTitle`. If you need to do something other than presenting an alert controller, you can set this closure.

```swift
locationPicker.locationDeniedHandler = { (locationPicker) in
    // Ask user to grant location access of this app.
}
```

### Delegate and Data Source

To use a delegate or data source, the following steps need to be taken:

1. Conform to `LocationPickerDelegate` or `LocationPickerDataSource`
```swift
class YourViewController: LocationPickerDelegate, LocationPickerDataSource
```
2. Set `delegate` or `dataSource` to this class
```swift
locationPicker.delegate = self
locationPicker.dataSource = self
```
3. Implement methods in `delegate` or `dataSource`

##### Location Pick

This delegate method is used to get user's final decision. It would be called only once for every `LocationPicker` object when it is about to be dismissed.

```swift
func locationDidPick(locationItem: LocationItem) {
    // Do something with the location the user picked.
}
```

##### Location Selection

This delegate method is used to get user's every location selection. It would be called every time user chooses a location in the list or drag the map view.

```swift
func locationDidSelect(locationItem: LocationItem) {
    // Do something with user's every selection.
}
```

##### Alternative Locations

This data source method is used to provide locations that show under current location and search result locations. Instead of using delegate, you can also just set the `alternativeLocations` property.

```swift
func numberOfAlternativeLocations() -> Int {
    // Get the number of locations you need to add to the location list.
    return count
}
func alternativeLocationAtIndex(index: Int) -> LocationItem {
    // Get the location item for the specific index.
    return locationItem
}
```

##### Location Deletion

If `alternativeLocations` is not empty and `alternativeLocationEditable` is set to `true`, this data source method will be called when user delete a location item in the table view.

```swift
func commitAlternativeLocationDeletion(locationItem: LocationItem) {
    // Delete the location.
}
```

##### Permission Denied Handler

By default, when user request current location but denied the app's location access, `LocationPicker` will present an alert controller that links to the Settings. You can change the text in the alert controller by calling `func setLocationDeniedAlertControllerTitle`. If you need to do something other than presenting an alert controller, you can set this delegate method.

```swift
func locationDidDeny(locationPicker: LocationPicker) {
    // Ask user to grant location access of this app.
}
```

### Override

If you prefer to subclass `LocationPicker`, these methods can be overridden to achieve the same result as closure and delegate.

##### Location Pick

This method is used to get user's final decision. It would be called only once for every `LocationPicker` object when it is about to be dismissed.

```swift
override func locationDidPick(locationItem: LocationItem) {
    // Do something with the location the user picked.
}
```

##### Location Selection

This method is used to get user's every location selection. It would be called every time user chooses a location in the list or drag the map view.

__Note__: If you override these methods, the corresponding closure and delegate method won't be executed.

```swift
override func locationDidSelect(locationItem: LocationItem) {
    // Do something with user's every selection.
}
```

##### Location Deletion

If `alternativeLocations` is not empty and `alternativeLocationEditable` is set to `true`, this method will be called when user delete a location item in the table view.

```swift
override func alternativeLocationDidDelete(locationItem: LocationItem) {
    // Delete the location.
}
```

##### Permission Denied Handler

By default, when user request current location but denied the app's location access, `LocationPicker` will present an alert controller that links to the Settings. You can change the text in the alert controller by calling `func setLocationDeniedAlertControllerTitle`. If you need to do something other than presenting an alert controller, you can set this method.

```swift
override func locationDidDeny(locationPicker: LocationPicker) {
    // Ask user to grant location access of this app.
}
```

## Location Item

`LocationItem` is a encapsulation class of `MKMapItem` to save you from importing `MapKit` everywhere in your project. To make it more convenient to use, it equips with several computing properties to access the `MKMapItem`.

### Storage

`LocationItem` is conformed to `NSCoding`, which means `LocationItem` object can be encoded to `NSData` object and decoded back.

```swift
let locationData = NSKeyedArchiver.archivedDataWithRootObject(locationItem)
let locationItem = NSKeyedUnarchiver.unarchiveObjectWithData(locationData) as! LocationItem
```

### Equatable

The hash value of `LocationItem` is `"\(coordinate.latitude), \(coordinate.longitude)".hashValue`, so objects that have the same latitude and longitude are equal.

### Properties

| Property name | Type | Target | Remark |
| ------------- |:----:| ------ | ------ |
| name | String | mapItem.name | The name of the location |
| coordinate | (latitude: Double, longitude: Double)? | mapItem.placemark.coordinate | The coordinate of the location and converted to tuple. If the user is offline or there is no search result and the `allowArbitraryLocation` property of `LocationPicker` is set to `true`, this property will be `nil` |
| addressDictionary | [NSObject: AnyObject]? | mapItem.placemark.addressDictionary | The address dictionary of the location |
| formattedAddressString | String? | addressDictionary?["FormattedAddressLines"] | The address text formatted according to user's region |

If you want to access other properties of `MKMapItem` object, just call `locationItem.mapItem`.

### Initialization

##### `init(mapItem: MKMapItem)`

Since `LocationItem` is just the encapsulation of `MKMapItem`, of course you can create a `LocationItem` with a `MKMapItem` object.

##### `init(coordinate: (latitude: Double, longitude: Double), addressDictionary: [String: AnyObject])`

You can also initialize with the coordinate and address dictionary.

If you don't want to store `LocationItem` objects as `NSData`, you can just store the coordinate and address dictionary, and use this method to initialize.

#### `init(locationName: String)`

A location can be created with only a name. In this case, the value of property `coordinate` would be `nil`.

## Change Log

[CHANGELOG.md](https://github.com/JeromeTan1997/LocationPicker/blob/master/CHANGELOG.md)

## Contribute

* If you encounter any bugs or other problems, please create issues or pull requests.
* If you want to add more features to `LocationPicker`, you are more than welcome to create pull requests.
* If you are good at English, please correct my English.
* If you like the project, please star it and share with others.
* If you have used LocationPicker in your App, please tell me by creating an issue.

## License

The MIT License (MIT)

Copyright (c) 2016 Jerome Tan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
