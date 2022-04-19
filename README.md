[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Regula Document Reader SDK (iOS version)
Regula Document Reader SDK allows you to read various kinds of identification documents, passports, driving licenses, ID cards, etc. All processing is performed completely ***offline*** on your device. No any data leaving your device.

You can use native camera to scan the documents or image from gallery for extract all data from it.

We have provided sample projects that demonstrate the ***API*** calls you can use to interact with the Document Reader library.

<img src="https://img.regulaforensics.com/Screenshots/SDK-5.0/iPhone_XS_Max_1.jpg" width="250"> <img src="https://img.regulaforensics.com/Screenshots/SDK-5.0/iPhone_XS_Max_2.jpg" width="250"> <img src="https://img.regulaforensics.com/Screenshots/SDK-5.0/iPhone_XS_Max_3.jpg" width="250">

# Content
* [How to build demo application](#how-to-build-demo-application)
* [Troubleshooting license issues](#troubleshooting-license-issues)
* [Documentation](#documentation)
* [Additional information](#additional-information)

## How to build demo application
1. Visit [client.regulaforensics.com](https://client.regulaforensics.com) to get a trial license (`regula.license` file). The license creation wizard will guide you through the necessary steps.
1. Download or clone the current repository using the command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`.
1. Repository structure and steps to build the projects:
    1. `Advanced` folder contains the advanced sample project with almost all available features. To build it, do the following steps:
        1. Go to the `Advanced` folder. There you will find the project written in Swift.
        1. Go to the project folder.
        1. Install Pods: open Terminal within the root project folder and run `pod install` command.
        1. Copy the license file to the project: `Advanced/DocumentReader-Swift/DocumentReader-Swift`.
        1. Open the project in Xcode (`DocumentReader-Swift.xcworkspace` file).
        1. Run the project.
    
    1. `Basic` folder contains the basic sample project with only main features. To build it, do the following steps:
        1. Go to the `Basic` folder. There you will two projects: one is written in Swift, another in Objective-C.
        1. Go to the project folder: `DocumentReaderObjectiveC-sample` or `DocumentReaderSwift-sample`.
        1. Install Pods: open Terminal within the root project folder and run `pod install` command.
        1. Copy the license file to the project: `Basic/DocumentReaderObjectiveC-sample/DocumentReaderObjectiveC-sample` or `Basic/DocumentReaderSwift-sample/DocumentReaderSwift-sample`.
        1. Open the project in Xcode (`DocumentReaderObjectiveC-sample.xcworkspace` or `DocumentReaderSwift-sample.xcworkspace` file).
        1. Run the project.

## Troubleshooting license issues
If you have issues with license verification when running the application, please verify that next is true:
* The OS, which you use, is specified in the license (iOS).
* The license is valid (not expired).
* The date and time on the device, where you run the application, are valid.
* You use the latest release version of the Document Reader SDK.
* You placed the license into the correct folder.

## Documentation
You can find documentation on API [here](https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile?utm_source=github).

## Additional information
If you have any technical questions, feel free to [contact](mailto:ios.support@regulaforensics.com) us or create issue [here](https://github.com/regulaforensics/DocumentReader-iOS/issues).

To use our SDK in your own app you need to [purchase](https://pipedrivewebforms.com/form/394a3706041290a04fbd0d18e7d7810f1841159) a commercial license.
