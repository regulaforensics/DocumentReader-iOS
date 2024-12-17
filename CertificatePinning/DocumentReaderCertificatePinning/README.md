[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Document Reader SDK Certificate Pinning Sample Project (iOS)

* [Overview](#overview)
* [Installation](#installation)
* [Configuration of Certificate Pinning](#configuration-of-certificate-pinning)
* [Documentation](#documentation)
* [Demo Application](#demo-application)
* [Technical Support](#technical-support)
* [Business Enquiries](#business-enquiries)

## Overview

Sample project in Swift, demonstrating how to set up and use the <a target="_blank" href="https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/security/certificate-pinning/">Certificate Pinning</a> feature.

## Installation

1. Download or clone the current repository using the command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`
2. Open the `DocumentReaderCertificatePinning` project in an IDE.
3. Run pods `pod install`
4. Add license and database files to the target:
    - Visit [Regula Client Portal](https://client.regulaforensics.com/) to get a trial license (`regula.license` file). The license creation wizard will guide you through the necessary steps.
    - Copy the license file to the project: `CertificatePinning/DocumentReaderCertificatePinning/DocumentReaderCertificatePinning/`
    - Copy the database file `db.dat` from [Regula Client Portal](https://client.regulaforensics.com/customer/databases) to the project:`CertificatePinning/DocumentReaderCertificatePinning/DocumentReaderCertificatePinning/`
5. Change the application Bundle ID to the one you have specified during the registration at [Regula Client Portal](https://client.regulaforensics.com/).

## Configuration of Certificate Pinning

**Note:** Requires iOS 14.0 minimum deployment target.

Check the [official Apple documentation for Identity Pinning](https://developer.apple.com/news/?id=g9ejcf8y) for iOS devices.

See the article [how to generate key for the app](https://nikunj-joshi.medium.com/ssl-pinning-increase-server-identity-trust-656a2fc7e22b).

1. In the `Info.plist` file add `NSPinnedDomains` section to the `NSAppTransportSecurity` section.
2. Add your domain. Set `YES` for`NSIncludesSubdomains` to spread pinning over all subdomains.
3. In the domain `NSPinnedLeafIdentities` array use your generated 'SHA-256' hash key.

## Documentation

<a target="_blank" href="https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/">Document Reader SDK Mobile Documentation</a>

## Demo Application

<a target="_blank" href="https://apps.apple.com/us/app/regula-document-reader/id1001303920">Regula Document Reader iOS Demo Application in the App Store</a>

## Technical Support

To submit a request to the Support Team, visit <a target="_blank" href="https://support.regulaforensics.com/hc/en-us/requests/new?utm_source=github">Regula Help Center</a>.

## Business Enquiries

To discuss business opportunities, fill the <a target="_blank" href="https://explore.regula.app/docs-support-request">Enquiry Form</a> and specify your scenarios, applications, and technical requirements.