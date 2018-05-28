[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Regula Document Reader (iOS version)

The DocumentReader is a framework for identification documents reading and validation which is working fully **offline**. It contains two parts DocumentReader.framework that use like API for frameworks users. And DocumentReaderCore.framework that performs all main logic. [Just take me to the notes!](https://github.com/regulaforensics/DocumentReader-iOS/wiki)

If you have any questions, feel free to [contact us](mailto:support@regulaforensics.com).

<img src="DocumentReaderDemo_main.png" width="250"> <img src="DocumentReaderDemo_process.png" width="250"> <img src="DocumentReaderDemo_result.png" width="250">

# Content

* [How to build demo application](#how_to_build_demo_application)
* [How to add DocumentReader library to your project](#how_to_add_documentreader_library_to_your_project)
* [Troubleshooting license issues](#troubleshooting_license_issues)
* [Additional information](#additional_information)

## <a name="how_to_build_demo_application"></a> How to build demo application

You could easily use framework in both languages Swift or Objective C. 
1. Get trial license for demo application at [licensing.regulaforensics.com](https://licensing.regulaforensics.com) (`regula.license` file).
1. Download or clone current repository using command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`.
1. Download and install latest [Xcode](https://developer.apple.com/xcode/download).
1. Copy file `regula.license` to `Samples/DocumentReaderSwift-sample/DocumentReaderSwift-sample` folder or `Samples/DocumentReaderObjectiveC-sample/DocumentReaderObjectiveC-sample` for Objective C example.
1. Open workspace `Samples/DocumentReaderSwift-sample/DocumentReaderSwift-sample.xcworkspace` in Xcode or `Samples/DocumentReaderObjectiveC-sample/DocumentReaderObjectiveC-sample.xcworkspace` for Objective C sample.
1. Change bundle ID to specified during registration of your license key at [licensing.regulaforensics.com](https://licensing.regulaforensics.com) (`regula.DocumentReader` by default).
1. Select target `Pod install` and run it. Optionally you may install pods manually by running `pod install` in `Samples/DocumentReaderSwift-sample` directory

## <a name="how_to_add_documentreader_library_to_your_project"></a> How to add DocumentReader to your project

DocumentReader is [available](https://cocoapods.org/pods/DocumentReader) via [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:
 
 * Install Full library edition:
 ```ruby
 pod 'DocumentReader'
 pod 'DocumentReaderFull'
 ```
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
* Install OCR library edition:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderOCR'
```
* Install Band Card library edition:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderBankCard'
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
