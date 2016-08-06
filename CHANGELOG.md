# Change Log

## [2.0.0](https://github.com/JeromeTan1997/LocationPicker/releases/tag/2.0.0) (2016-08-06)

#### Enhancements

- Add a Bool property `var forceReverseGeocoding` to decide if reverse geocoding should be performed [#9](https://github.com/JeromeTan1997/LocationPicker/pull/9)
- Migrate to Swift 2.3 and support iOS 10
- `func selectLocaitonItem` is now public in order to allow setting a default location [#9](https://github.com/JeromeTan1997/LocationPicker/pull/9)
- Enable filtering search results [#9](https://github.com/JeromeTan1997/LocationPicker/pull/9)
- Add a Bool property `var isRedirectToExactCoordinate` to decide whether redirect to the exact coordinate after queried
- Avoid duplicate texts in table view cells

#### Bug fixes

- Fix the misuse of NSCoding
- Fix the misuse of layout guide
- Fix the framework linking problem in demo
- Fix the coordinate offset in iOS 10

## [1.2.0](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.2.0) (2016-06-10)

#### Enhancements

- Add the capability to allow the selection of locations that did not match or exactly match search results [#6](https://github.com/JeromeTan1997/LocationPicker/pull/6)

## [1.1.2](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.1.2) (2016-06-10)

#### API breaking changes

- Rename `func addButtons` to `func addBarButtons`
- Move `doneButtonItem` property to tuple `barButtonsItems`

#### Enhancements

- Make `cancelButtonItem` public

#### Bug fixes

- Fix the issue that the **LocatiobPicker.framework** is missing in demo app [#7](https://github.com/JeromeTan1997/LocationPicker/issues/7)

## [1.1.1](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.1.1) (2016-05-09)

#### Enhancements

- Support offline location for `LocationItem`

#### Bug fixes

- Fix a typo in demo

## [1.1.0](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.1.0) (2016-05-08)

#### Enhancements

- Support offline location entry [#5](https://github.com/JeromeTan1997/LocationPicker/pull/5)

## [1.0.4](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.0.4) (2016-05-06)

#### Bug fixes

- Fix the issue with Carthage [#3](https://github.com/JeromeTan1997/LocationPicker/issues/3)

## [1.0.3](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.0.3) (2016-04-12)

#### API breaking changes

- Rename `func customizeLocationDeniedAlertController` to `func setLocationDeniedAlertControllerTitle`

#### Enhancements

- Support Objective-C [#1](https://github.com/JeromeTan1997/LocationPicker/issues/1)

## [1.0.2](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.0.2) (2016-04-12)

#### Enhancements

- Swift Package Manager support

## [1.0.1](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.0.1) (2016-04-10)

#### Enhancements

- iOS 8 support

## [1.0.0](https://github.com/JeromeTan1997/LocationPicker/releases/tag/1.0.0) (2016-04-09)

- Initial release
