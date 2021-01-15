## 0.2.[n]
* Change the code to use plugin interface.
* Delete some logic to allow the plugin interface to manage it
* Send the options, listeners and response definitions to the plugin interface that allows it to be common to all platform implementations
* Add `JitsiMeetConferencing` class to implement the View needed for web 

## 0.2.5
* Added Android support to close the meeting programmatically

## 0.2.4
* IOS Xcode 11.5 support

## 0.2.3
* Added support for pass JWT token

## 0.2.2
* Added support for feature flags


## 0.2.1
* Updated JitsiMeet SDK to v2.9.0 

## 0.2.0
* Added IOSAppBarRGBAColor Param

## 0.1.9

* Upgrading to IOS Cocoapods JitsiMeet v2.8.1


## 0.1.9pod install


* Fix defects for Android and SDK version

## 0.1.8y

* Fix defect for ISO Xcode 11.4 compile architecture issues

## 0.1.7

* Fix defect with per meeting listener not initializing event channel

## 0.1.6

* Added per meeting listeners
* Added Map<dynamic, dynamic> data returned in listener functions

## 0.1.5

* Support for Meeting Events: onConferenceWillJoin,
onConferenceJoined, onConferenceTerminated, and onError

## 0.1.4

* Move and rename Kotlin TAG variable into plugin class 
to eliminate naming conflicts

## 0.1.3+1

* Example app proguard to fix release apk build crashing
* Update README about proguard and minimum sdk

## 0.1.3

* Added support for serverURL

## 0.1.2

* Update license to MIT

## 0.1.1

* Room name character validation.
* Allow nullable fields in iOS.

## 0.1.0

* Initial release for Android and iOS.