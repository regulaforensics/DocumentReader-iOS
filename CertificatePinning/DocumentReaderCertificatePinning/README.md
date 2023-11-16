# Regula Document Reader (iOS version)
The sample project for working with the 
[Mobile document authenticator Regula 1120](https://regulaforensics.com/en/products/machine_verification/1120/).

# Content
* [How to build the demo application](#how-to-build-the-demo-application)
* [Documentation](#documentation)
* [Additional information](#additional-information)

## How to build the demo application
1. Download or clone the current repository using the command `git clone https://github.com/regulaforensics/DocumentReader-iOS.git`.
2. Open the `DocumentReaderCertificatePinning` project in an IDE.
3. Run pods `pod install`

## How to configure Certificate Pinning
* Requires iOS 14.0 minimum deployment target 

Here is an [official documentation for Identity Pinning](https://developer.apple.com/news/?id=g9ejcf8y) for iOS devices.
 
Here you can find [how to generate key for the app](https://nikunj-joshi.medium.com/ssl-pinning-increase-server-identity-trust-656a2fc7e22b).

1. In the Info.plist file add `NSPinnedDomains` section in the `NSAppTransportSecurity` section.
2. Add your domain. Set YES for`NSIncludesSubdomains` to spread pinning over all subdomains.
3. In the domain NSPinnedLeafIdentities array use your generated 'SHA-256' hash key.

## Documentation
The documentation on the SDK can be found [here](https://docs.regulaforensics.com/develop/doc-reader-sdk/mobile?utm_source=github).

## Additional information
If you have any technical questions or suggestions, feel free to [contact](mailto:android.support@regulaforensics.com) us or create an issue [here](https://github.com/regulaforensics/DocumentReader-iOS/issues).
