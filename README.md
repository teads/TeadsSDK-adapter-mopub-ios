# Teads - iOS MoPub Mediation Adapter
> Mediation adapter to be used in conjunction with MoPub to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through MoPub mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 10+](https://img.shields.io/badge/Platform-iOS%2010%2B-blue.svg?style=flat)
- ![Xcode: 11.0+](https://img.shields.io/badge/Xcode-11.0+-blue.svg?style=flat)
- ![MoPub SDK: 5.13+](https://img.shields.io/badge/MoPub%20SDK-5.13+-blue.svg?style=flat)
- ![Teads SDK: 4.8.0+](https://img.shields.io/badge/Teads%20SDK-4.8.0+-blue.svg?style=flat)

## Features

- [x] Displaying Teads banners

## Installation

Before installing Teads adapter, you need to implement [MoPub Ads](https://developers.mopub.com/docs/ios/) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `MoPub-Teads-Adapters` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'MoPub-Teads-Adapters'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000166728-mopub-ios#defining_a_custom_event) step to finish the integration.
4. You’re done.

#### Manually

1. Integrate latest version of Teads SDK to your project using this [Quick Start Guide](https://support.teads.tv/support/solutions/articles/36000165909-ios).
2. Download latest release of [`TeadsMoPubAdapter`](https://github.com/teads/TeadsSDK-iOS/releases).
3. Drop adapter files in your iOS project.
4. Follow the [Define Custom Event](https://support.teads.tv/support/solutions/articles/36000166728-mopub-ios#defining_a_custom_event) step to finish the integration.
5. You’re done.

## Integration Documentation

Integration instructions are available on [Teads SDK Documentation](https://support.teads.tv/support/solutions/articles/36000166728-mopub-ios).

## Changelog

See [CHANGELOG](CHANGELOG.md). 
