[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Auto Mode Online Processing Sample Project (iOS)

* [Overview](#overview)
* [Installation](#installation)
* [Documentation](#documentation)
* [Demo Application](#demo-application)
* [Technical Support](#technical-support)
* [Business Enquiries](#business-enquiries)

## Overview

Sample project in Swift, demonstrating the Document Reader SDK setup for <a target="_blank" href="https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/integration/online-processing/#auto-mode">Online Processing in the Auto Mode</a>. In this mode, the document processing is performed both on the mobile side and on the Web API service. 

So the mobile application needs to be initialized with the dedicated license.

## Installation

1. Download or clone the current repository using the command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`.
2. Open the `OnlineProcessing-With-License-Swift` project in an IDE.
3. Run pods `pod install`.
4. Add license and database files to the target:
    - Visit [Regula Client Portal](https://client.regulaforensics.com/) to get a trial license (`regula.license` file). The license creation wizard will guide you through the necessary steps.
    - Copy the license file to the project: `OnlineProcessing/OnlineProcessing-With-License-Swift/OnlineProcessing-With-License-Swift/`
5. Change the application Bundle ID to the one you have specified during the registration at [Regula Client Portal](https://client.regulaforensics.com/).

## Documentation

<a target="_blank" href="https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/">Document Reader SDK Mobile Documentation</a>

## Demo Application

<a target="_blank" href="https://apps.apple.com/us/app/regula-document-reader/id1001303920">Regula Document Reader iOS Demo Application in the App Store</a>

## Technical Support

To submit a request to the Support Team, visit <a target="_blank" href="https://support.regulaforensics.com/hc/en-us/requests/new?utm_source=github">Regula Help Center</a>.

## Business Enquiries

To discuss business opportunities, fill the <a target="_blank" href="https://explore.regula.app/docs-support-request">Enquiry Form</a> and specify your scenarios, applications, and technical requirements.