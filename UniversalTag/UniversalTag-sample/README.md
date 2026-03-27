[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Basic Swift Sample Project (iOS)

* [Overview](#overview)
* [Installation](#installation)
* [Documentation](#documentation)
* [Demo Application](#demo-application)
* [Technical Contacts](#technical-contacts)
* [Business Contacts](#business-contacts)

## Overview

Sample project in Swift, demonstrating the Document Reader SDK basic functionality and shows how to integrate reading NFC via external Bluetooth device. UI elements are not included.

**Important:** this project does **not** include a Bluetooth Reader SDK. It contains the key integration points and required methods only.


## Installation

1. Download or clone the current repository using the command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`.
2. Open the `DocumentReaderSwift-sample` project in an IDE.
3. Run pods `pod install`.
4. Add license and database files to the target:
    - Visit [Regula Client Portal](https://client.regulaforensics.com/) to get a trial license (`regula.license` file). The license creation wizard will guide you through the necessary steps.
    - Copy the license file to the project: `UniversalTag/UniversalTag-sample/DocumentReaderSwift-sample/`
    - Copy the database file `db.dat` from [Regula Client Portal](https://client.regulaforensics.com/customer/databases) to the project: `UniversalTag/UniversalTag-sample/DocumentReaderSwift-sample/`
5. Change the application Bundle ID to the one you have specified during the registration at [Regula Client Portal](https://client.regulaforensics.com/).

## Required Steps to Implement RFID reading with an External Bluetooth Reader
1. Conform the `RGLUniversalNFCTagTransport` protocol in your BLE SDK.
2. Implement sending APDU commands from `RGLUniversalNFCTagTransport` to your BLE SDK and return response.
3. Establish a connection to the external Bluetooth reader using your BLE SDK.
4. Detect and confirm that the NFC tag is available through the connected reader.
5. After the Bluetooth reader and the NFC tag are ready, provide an object conforming to `RGLUniversalNFCTagTransport` to `DocReader.shared.readRFID(universalNFCTag:notificationCallback:completion:)`. At this stage, `DocumentReader` uses the provided transport object to exchange APDU commands with the tag through your BLE SDK.


## Documentation

<a target="_blank" href="https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/">Document Reader SDK Mobile Documentation</a>

## Demo Application

<a target="_blank" href="https://apps.apple.com/us/app/regula-document-reader/id1001303920">Regula Document Reader iOS Demo Application in the App Store</a>

## Technical Contacts

To submit a request to Technical Support, visit <a target="_blank" href="https://support.regulaforensics.com/hc/en-us/requests/new?utm_source=github">Regula Help Center</a>.

## Business Contacts

To discuss business purposes or purchase the license, fill the <a target="_blank" href="https://explore.regula.app/docs-support-request">Enquiry Form</a>.
