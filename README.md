# Teads - iOS MoPub Mediation Adapter
> Mediation adapter to be used in conjunction with MoPub to deliver Teads ads on iOS devices.

If you want to display Teads ads in your iOS application through MoPub mediation, you’re at the right place.

## Requirements

- ![Platform: iOS 9+](https://img.shields.io/badge/Platform-iOS%209%2B-blue.svg?style=flat)
- ![Xcode: 9.0+](https://img.shields.io/badge/Xcode-9.0+-blue.svg?style=flat)
- ![MoPub SDK: 5.0.0+](https://img.shields.io/badge/MoPub%20SDK-5.0.0+-blue.svg?style=flat)
- ![Teads SDK: 4.0.7+](https://img.shields.io/badge/Teads%20SDK-4.0.7+-blue.svg?style=flat)

## Features

- [x] Displaying Teads banners

## Installation

Before installing Teads adapter, you need to implement [MoPub Ads](https://developers.mopub.com/docs/ios/) in your application.

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install Teads adapter and Teads SDK.

1. Add pod named `MoPub-Teads-Adapters` in your Podfile:

```ruby
platform :ios, '9.0'
pod 'MoPub-Teads-Adapters'
```

2. Run `pod install --repo-update` to install the adapter in your project.
3. Follow the [Define Custom Event](#define-custom-event) step to finish the integration.
4. You’re done.

#### Manually

1. Integrate latest version of Teads SDK to your project using this [Quick Start Guide](http://mobile.teads.tv/sdk/documentation/v4/ios/get-started).
2. Download latest release of [`TeadsMoPubAdapter`](https://github.com/teads/TeadsSDK-iOS/releases).
3. Drop adapter files in your iOS project.
4. Follow the [Define Custom Event](#define-custom-event) step to finish the integration.
5. You’re done.

## Documentation

### Define Custom Event

In order to display a Teads ad through MoPub mediation, you need to create a [custom SDK network](https://developers.mopub.com/docs/ui/networks/#unsupported-network-setup) on [MoPub dashboard](https://app.mopub.com/networks).

When creating a custom SDK network, you are required to define these informations:

| Name                        | Description                                    |
|-----------------------------|------------------------------------------------|
| `Custom Event Class`        | Class name of the adapter                      |
| `Custom Event Class Data`   | JSON configuration for the network             |

1. For `Custom Event Class` parameter, you need to use one of these names depending on ad type:

- Banner ad: `MPAdapterTeadsBanner`
- Interstitial ad: `MPAdapterTeadsInterstitial`
- Rewarded ad: `MPAdapterTeadsRewardedVideo`

2. For the `Custom Event Class Data` parameter, you need to put this JSON settings dictionnary.

```
{"PID":"__publisher_PID__"}
```

**Important note #1:** Don't forget to replace `__publisher_PID__` with your Teads placement ID.

**Important note #2:** Depending on your integration method, you need to prefix `Custom Event Class` like this:

- if you're using our Objective-C framework or standalone class files:
  - Banner ad: `MPAdapterTeadsBanner`
  - Interstitial ad: `MPAdapterTeadsInterstitial`
  - Rewarded ad: `MPAdapterTeadsRewardedVideo`

- if you're using our Swift framework:
  - Banner ad: `TeadsMoPubAdapter.MPAdapterTeadsBanner`
  - Interstitial ad: `TeadsMoPubAdapter.MPAdapterTeadsInterstitial`
  - Rewarded ad: `TeadsMoPubAdapter.MPAdapterTeadsRewardedVideo`

- if you're using our Swift standalone class files:
  - Banner ad: `__module_name__.MPAdapterTeadsBanner`
  - Interstitial ad: `__module_name__.MPAdapterTeadsInterstitial`
  - Rewarded ad: `__module_name__.MPAdapterTeadsRewardedVideo`

Where you need to replace `__module_name__` by the name of your app/framework module in which you integrate the adapter:
- `appName`
- `appName_targetName` (if you have multiple targets in your project or if the project name is different from the target name) 

Remember to replace any non-alphanumeric characters such as dashes with underscores.

**Example #1:** If you add a Teads interstitial placement in MoPub and you integrate the adapter through our Swift class files in a Swift app named "Demo", you'll use `Demo.MPAdapterTeadsInterstitial` for `Custom Event Class`.

**Example #2:** If you add a Teads rewarded ad placement in MoPub and you integrate the adapter through our Swift framework in a Swift app named "Demo", you'll use `TeadsMoPubAdapter.MPAdapterTeadsRewardedVideo` for `Custom Event Class`.

**Example #3:** If you add a Teads banner placement in MoPub and you integrate the adapter through our ObjC class files in an ObjC app named "Demo", you'll use `MPAdapterTeadsBanner` for `Custom Event Class`.

### Mediation Settings

For MoPub rewarded videos, you have the ability to pass [mediation settings](https://developers.mopub.com/docs/ios/rewarded-video/#advanced-mediation-settings) in order to customize third-party ad networks settings.
For Teads, you need to use `TeadsInstanceMediationSettings` class to pass mediation settings.

**Note**: Only available for rewarded ads.

1. Create an instance of `TeadsInstanceMediationSettings`.
2. Populate it with your custom settings.
3. Register it into `MPRewardedVideo` using `loadAdWithAdUnitID:withMediationSettings:` method.
4. Teads rewarded ad will receive your specific mediation settings when it will load.

```swift
// Create mediation settings for Teads rewarded ad
let mediationSettings = TeadsInstanceMediationSettings()
mediationSettings.debugMode = true
mediationSettings.locationDisabled = true

// Load video
MPRewardedVideo.loadAd(withAdUnitID: adUnitID, withMediationSettings: [mediationSettings])
```

Here is a list of available mediation settings:

| Settings                                                  | Description                                                                                                                                             |
|-----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `public var debugMode`                                           | Enable/disable debug logs from Teads SDK.                                                                                                                       |
| `public var locationDisabled`                               | Enable/disable collection of user location. By default, SDK will collect user location if corresponding permissions has been granted to the host application. |
| `public var mediaPreloadDisabled`                                   | Enable/disable preload of media files (like videos). If disabled, media files will be loaded lazily.                                                          |
| `public var publisherPageUrl`                                  | Sets the publisher page url where ad will be loaded into (for brand safety purposes).                                                                   |
| `public var lightEndscreen`                                     | Enable/disable light mode for the ad end screen. By default, dark mode is used.                                                                                    |

## Changelog

See [CHANGELOG](CHANGELOG.md). 
