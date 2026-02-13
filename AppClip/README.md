[![Version](https://img.shields.io/cocoapods/v/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![License](https://img.shields.io/cocoapods/l/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)
[![Platform](https://img.shields.io/cocoapods/p/DocumentReader.svg?style=flat)](http://cocoapods.org/pods/DocumentReader)

# Document Reader App Clip

This project contains an iOS App Clip implementation for document scanning using Regula Document Reader SDK.

---

## Overview

The App Clip allows users to scan QR codes with the native iOS camera, which opens the App Clip and initiates document scanning with RFID chip reading capabilities.

---

## Requirements

- iOS 17.0+
- Regula Document Reader SDK 9.1.0+ (required)
- Regula Document Reader Core 9.1.0+ (required)

---

## Installation

This project uses CocoaPods for dependency management.

1. **Clone the repository:**
   ```bash
   git clone https://github.com/regulaforensics/DocumentReader-iOS.git
   ```

2. **Open the `AppClip-sample` project in an IDE.**

3. **Install dependencies:**
   ```bash
   pod install
   ```

4. Add license and database files to the target:
    - Visit [Regula Client Portal](https://client.regulaforensics.com/) to get a trial license (`regula.license` file). The license creation wizard will guide you through the necessary steps.
    - Copy the license file to the project: `AppClip/DocumentReaderSwift-sample/`
    - Copy the database file `db.dat` from [Regula Client Portal](https://client.regulaforensics.com/customer/databases) to the project: `AppClip/DocumentReaderSwift-sample/`

5. **Open the workspace** (not the project file):
   - Open `DocumentReaderSwift-sample.xcworkspace` in Xcode

6. **Configure signing:**
   - Select your App Clip target
   - Go to "Signing & Capabilities"
   - Configure your development team and signing certificates

7. **Build and run:**
   - Select a physical iOS device (App Clips cannot run on simulator)
   - Build and run the App Clip target

---

## Setup Instructions

There are two different ways to configure App Clip Experience depending on your use case:

1. **[Local Development Setup](#1-local-development-setup)** - For testing on your development device
2. **[Production Setup (Online Version)](#2-production-setup-online-version)** - For deploying to production with AASA file

Choose the appropriate section based on your needs.

<a id="1-local-development-setup"></a>
### 1. Local Development Setup

**Use this setup when:** You want to test the App Clip on your development device before deploying to production.

This method allows you to manually configure App Clip Experiences on your iPhone through Developer settings, without needing to deploy an AASA file to a web server.

#### Step 1: Enable Developer Mode

1. On your iPhone, go to **Settings → Privacy & Security → Developer Mode**
2. Enable **Developer Mode**
3. Restart your device if prompted

#### Step 2: Configure App Clip Experience on Device

Configure App Clip Experience directly on your iPhone:

1. On your iPhone, go to **Settings → Developer**
2. Scroll down and look for **"App Clips Testing"** option
3. Tap **"Local Experiences"**
4. Tap the **"Register Local Experience..."** button to add a new experience
5. Configure the experience with the following details:
   - **URL Prefix:** `https://api.regulaforensics.com`
   - **Bundle Id:** `regula.DocumentReader.Clip`
   - **Title:** `Any Text`
   - **Subtitle:** `Any Text`


#### Step 3: Verify App Clip Bundle ID

Ensure your App Clip's Bundle ID is correctly configured:

1. In Xcode, select your **App Clip target**
2. Go to **"General"** tab
3. Check the **"Bundle Identifier"** field
4. Verify that the Bundle ID ends with `.Clip` or `.AppClip`
   - Example: `com.yourcompany.DocumentReaderAppClip.Clip`
5. The Bundle ID must match what you select in the App Clip Experience configuration on your device

#### Step 4: Test the App Clip

1. Scan a QR code containing the configured URL
2. The App Clip should launch automatically

---

<a id="2-production-setup-online-version"></a>
### 2. Production Setup (Online Version)

**Use this setup when:** [You want to deploy the App Clip to production and make it available to end users](https://developer.apple.com/documentation/appclip/associating-your-app-clip-with-your-website).

---

## Example Usage

To test the App Clip with a real document scanning session:

1. **Open the Regula Document Reader Web API:**
   - Navigate to [https://api.regulaforensics.com/](https://api.regulaforensics.com/)

2. **Start a scanning session:**
   - Click the **"Take a photo"** button on the website

3. **Select mobile device:**
   - Click the **"Mobile device"** option

4. **Scan the QR code:**
   - A QR code will be displayed on the website
   - Use your iPhone's native camera app to scan the QR code
   - The App Clip will automatically launch and begin document scanning

5. **Follow the on-screen instructions:**
   - The App Clip will guide you through the document scanning process
   - If your document has an RFID chip, the App Clip will automatically read it

---

## Notes

- App Clips cannot be tested on iOS Simulator - a physical device is required
- The App Clip has a size limit of 100MB
- Ensure proper network connectivity for backend processing
- For local testing, configure App Clip Experience on your device (see [Local Development Setup](#1-local-development-setup))
- For production deployment, deploy AASA file to your server (see [Production Setup (Online Version)](#2-production-setup-online-version))

---

## Documentation

<a target="_blank" href="https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile/">Document Reader SDK Mobile Documentation</a>

---

## Demo Application

<a target="_blank" href="https://apps.apple.com/us/app/regula-document-reader/id1001303920">Regula Document Reader iOS Demo Application in the App Store</a>

---

## Technical Support

To submit a request to the Support Team, visit <a target="_blank" href="https://support.regulaforensics.com/hc/en-us/requests/new?utm_source=github">Regula Help Center</a>.

---

## Business Enquiries

To discuss business opportunities, fill the <a target="_blank" href="https://explore.regula.app/docs-support-request">Enquiry Form</a> and specify your scenarios, applications, and technical requirements.
