[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Regula Document Reader (iOS version)
If you have any questions, feel free to contact us at support@regulaforensics.com

* [How to build demo application](#how_to_build_demo_application)
* [How to add DocumentReader library to your project](#how_to_add_documentreader_library_to_your_project)
* [Troubleshooting license issues](#troubleshooting_license_issues)
* [Additional information](#additional_information)

## <a name="how_to_build_demo_application"></a> How to build demo application
1. Get trial license for demo application at [licensing.regulaforensics.com](https://licensing.regulaforensics.com) (`regula.license` file).
1. Download or clone current repository using command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`.
1. Download and install latest [Xcode](https://developer.apple.com/xcode/download).
1. Copy file `regula.license` to `Samples/DocumentReaderSwift-sample/DocumentReaderSwift-sample` folder. 
1. Open workspace `Samples/DocumentReaderSwift-sample/DocumentReaderSwift-sample.xcworkspace` in Xcode.
1. Change bundle ID to specified during registration of your license key at [licensing.regulaforensics.com](https://licensing.regulaforensics.com) (`regula.DocumentReader` by default).
1. Select target `Pod install` and run it. Optionally you may install pods manually by running `pod install` in `Samples/DocumentReaderSwift-sample` directory
1. Select and run target which you would want to test:
* DocumentReaderCoreSwift-sample - to run with DocumentReader framework (Core library edition)
* DocumentReaderBoundsSwift-sample - to run with DocumentReader framework (Bounds library edition)
* Pod install - runs `pod install` command in `Samples/DocumentReaderSwift-sample` directory
![Targets](https://raw.githubusercontent.com/regulaforensics/DocumentReader-iOS/master/target_image.tiff)

## <a name="how_to_add_documentreader_library_to_your_project"></a> How to add DocumentReader to your project

DocumentReader is [available](https://cocoapods.org/pods/DocumentReader) via [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:
 
* Install Core library edition:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderCore'
``` 
* Install Bounds library edition:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderBounds'
```
* Install Barcode library edition:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderBarcode'
```
* Install MRZ library edition:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderMRZ'
```
* Install MRZ-Barcode library edition:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderMRZBarcode'
```

## <a name="troubleshooting_license_issues"></a> Troubleshooting license issues
If you have issues with license verification when running the application, please verify that next is true:
1. OS you are using is the same as in the license you received (iOS).
1. Bundle ID is the same that you specified for license.
1. Date and time on the device you are trying to run the application is correct and inside the license validity term.
1. You are using the latest release of the SDK.
1. You placed the license into the correct folder as described here [How to build demo application](#how_to_build_demo_application) (`DocumentReaderSwift-sample/DocumentReaderSwift-sample`).

## <a name="additional_information"></a> Additional information
If you have any questions, feel free to contact us at support@regulaforensics.com
