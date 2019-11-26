[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Regula Document Reader (iOS version)
Regula Document Reader SDK allows you to read various kinds of identification documents, passports, driving licenses, ID cards, etc. All processing is performed completely ***offline*** on your device. No any data leaving your device.

You can use native camera to scan the documents or image from gallery for extract all data from it.

We have provided a simple application that demonstrates the ***API*** calls you can use to interact with the DocumentReader Library.

<img src="https://img.regulaforensics.com/Screenshots/SDK-5.0/iPhone_XS_Max_1.jpg" width="250"> <img src="https://img.regulaforensics.com/Screenshots/SDK-5.0/iPhone_XS_Max_2.jpg" width="250"> <img src="https://img.regulaforensics.com/Screenshots/SDK-5.0/iPhone_XS_Max_3.jpg" width="250">

# Content
* [How to build the demo application](#how-to-build-the-demo-application)
* [How to add the SDK to the project](#how-to-add-the-sdk-to-the-project)
* [Troubleshooting license issues](#troubleshooting-license-issues)
* [Documentation](#documentation)
* [Additional information](#additional-information)

## How to build the demo application
1. Visit [licensing.regulaforensics.com](https://licensing.regulaforensics.com) to get a trial license (`regula.license` file). The license creation wizard will guide you through the necessary steps.

**Note**: optionally, you can also download the documents database (`db.dat` file) to add it to the project manually and use the app without the Internet. Otherwise, it'll be downloaded from the Internet while the app is running.

2. Download and install the latest [Xcode](https://developer.apple.com/xcode/download).
3. Download or clone current repository using the command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`.
4. Copy and add the `regula.license` file to `DocumentReaderSwift-sample/DocumentReaderSwift-sample` folder (for Swift example) or `DocumentReaderObjectiveC-sample/DocumentReaderObjectiveC-sample` folder (for Objective-C example). If the database has been downloaded manually, add it to the project in the same way as `regula.license` file.
5.  Open the workspace `DocumentReaderSwift-sample/DocumentReaderSwift-sample.xcworkspace` or `DocumentReaderObjectiveC-sample/DocumentReaderObjectiveC-sample.xcworkspace` (for Objective-C example) in Xcode.
6.  Change the Bundle ID to the one specified during registration at [licensing.regulaforensics.com](https://licensing.regulaforensics.com)(`regula.DocumentReader` is set by default).
7.  Select the target `Pod install` and run it to install the dependencies via Xcode, or you can install them manually, simply running `pod install` within the project directory via Terminal.
8. Build and run the application.

## How to add the SDK to the project
Document Reader libraries are available via [CocoaPods](https://cocoapods.org/owners/22498).
First of all, install API library, simply adding the following lines to the [`Podfile`](https://guides.cocoapods.org/using/the-podfile.html) file of your project:
```
pod 'DocumentReader'
```

And then add one of the [Core](https://docs.regulaforensics.com/ios/core) libraries depend on the functionality that you wish and the license capabilities:

* Install **Barcode** library edition:
```
pod 'DocumentReaderBarcode'
```

* Install **Bounds** library edition:
```
pod 'DocumentReaderBounds'
```

* Install **DocType** library edition:
```
pod 'DocumentReaderDocType'
```

* Install **Full** library edition:
```
pod 'DocumentReaderFull'
```

* Install **MRZ** library edition:
```
pod 'DocumentReaderMRZ'
```

* Install **MRZBarcode** library edition:
```
pod 'DocumentReaderMRZBarcode'
```

* Install **OCR** library edition:
```
pod 'DocumentReaderOCR'
```

## Troubleshooting license issues
If you have issues with license verification when running the application, please verify that next is true:
1. The OS, which you use, is specified in the license (iOS).
2. The Bundle Identifier, which you use, is specified in the license.
3. The license is valid (not expired).
4. The date and time on the device, where you run the application, are valid.
5. You use the latest release version of the Document Reader SDK.
6. You placed the license into the project.

## Documentation
The documentation on the SDK can be found [here](https://docs.regulaforensics.com/ios).

## Additional information
If you have any technical questions, feel free to [contact](mailto:ios.support@regulaforensics.com) us or create issue [here](https://github.com/regulaforensics/DocumentReader-iOS/issues).

To use our SDK in your own app you have to [purchase](https://pipedrivewebforms.com/form/394a3706041290a04fbd0d18e7d7810f1841159) a commercial license.
