[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# DocumentReader

## Installation

DocumentReader is [available](https://cocoapods.org/pods/DocumentReader) through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:
 
 1. Install Core version:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderCore'
```
 
 2. Install Bounds version:
```ruby
pod 'DocumentReader'
pod 'DocumentReaderBounds'
```

## Run Sample

1. Download repository
2. Put your trial license key (`regula.license` file) in DocumentReaderSwift-sample/DocumentReaderSwift-sample folder.
3. Open DocumentReaderSwift-sample.xcworkspace, select target "Pod install" and run it. Or install pods manually by run pod install in Samples/DocumentReaderSwift-sample directory 
```ruby
pod install
```
4. Get trial license for demo application at [licensing.regulaforensics.com](https://licensing.regulaforensics.com) (`regula.license` file).
5. Change bundle ID in demo application, specified during registration your license key.
6. Select and run target which you would want to test:
 * DocumentReaderCoreSwift-sample - for run DocumentReader framework with Core
 * DocumentReaderBoundsSwift-sample - for run DocumentReader framework with Bounds
 * Pod install - run pod install command in Samples/DocumentReaderSwift-sample directory
 
![Targets](https://user-images.githubusercontent.com/15870742/27986102-ae337f5e-6402-11e7-8292-aa88455dc22e.jpg)
