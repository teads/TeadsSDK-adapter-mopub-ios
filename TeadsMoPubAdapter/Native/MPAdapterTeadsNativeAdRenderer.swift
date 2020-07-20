//
//  MPAdapterTeadsNativeAdRenderer.swift
//  TeadsMoPubAdapter
//
//  Created by Thibaud Saint-Etienne on 09/06/2020.
//  Copyright © 2020 teads. All rights reserved.
//

import UIKit
import MoPub
import TeadsSDK

@objc public class MPAdapterTeadsNativeAdRenderer: NSObject, MPNativeAdRenderer {

    @objc public var viewSizeHandler: MPNativeViewSizeHandler!

    var rendererSettings: MPAdapterTeadsNativeAdRendererSettings!

    var adViewContainer: UIView?

    /// Publisher adView which is rendering.
    var adView: UIView?

    /// MPGoogleAdMobNativeAdAdapter instance.
    var adapter: MPNativeAdAdapter!

    /// YES if adView is in view hierarchy.
    var adViewInViewHierarchy: Bool?

    /// MPNativeAdRendererImageHandler instance.
    var renderingViewClass: AnyClass?

    /// Renderer settings are objects that allow you to expose configurable properties to the
    /// application. MPAdapterTeadsNativeAdRenderer renderer will be initialized with these settings.
    @objc required public init!(rendererSettings: MPNativeAdRendererSettings!) {
        viewSizeHandler = rendererSettings.viewSizeHandler
        self.rendererSettings = rendererSettings as? MPAdapterTeadsNativeAdRendererSettings
        renderingViewClass = self.rendererSettings.renderingViewClass
        adViewContainer = self.rendererSettings.adViewContainer
    }

    /// Construct and return an MPNativeAdRendererConfiguration object, you must set all the properties
    /// on the configuration object.
    @objc public static func rendererConfiguration(with rendererSettings: MPNativeAdRendererSettings!) -> MPNativeAdRendererConfiguration! {
        let config = MPNativeAdRendererConfiguration()
        config.rendererClass = MPAdapterTeadsNativeAdRenderer.self
        config.rendererSettings = rendererSettings
        config.supportedCustomEvents = [NSStringFromClass(MPAdapterTeadsNative.self)]
        return config
    }

    /// Returns an ad view rendered using provided |adapter|. Sets an |error| if any error is
    /// encountered.
    @objc public func retrieveView(with adapter: MPNativeAdAdapter!) throws -> UIView {
        guard let adapter = adapter as? MPAdapterTeadsMediatedNativeAd else {
            throw MPNativeAdNSErrorForRenderValueTypeError()
        }
        self.adapter = adapter

        renderTeadsNativeAdView(with: adapter)

        guard let adView = adView else {
            throw MPNativeAdNSErrorForRenderValueTypeError()
        }
        return adView
    }

    /// Creates Teads Native AdView with adapter. We added TeadsNativeAdView assets on
    /// top of MoPub's adView, to track impressions & clicks.
    func renderTeadsNativeAdView(with adapter: MPNativeAdAdapter) {

        registerContainer()

        guard let adView = adView as? MPNativeAdRendering,
            let adapter = adapter as? MPAdapterTeadsMediatedNativeAd else {
                return
        }

        // Title
        register(asset: adapter.teadsNativeAd.title,
                 in: adView.nativeTitleTextLabel?(),
                 respondingToSelector: "nativeTitleTextLabel",
                 withProperty: kAdTitleKey)

        // Main Text
        register(asset: adapter.teadsNativeAd.content,
                 in: adView.nativeMainTextLabel?(),
                 respondingToSelector: "nativeMainTextLabel",
                 withProperty: kAdTextKey)

        // Call to action
        register(asset: adapter.teadsNativeAd.callToAction,
                 in: adView.nativeCallToActionTextLabel?(),
                 respondingToSelector: "nativeCallToActionTextLabel",
                 withProperty: kAdCTATextKey)

        // Icon image
        register(asset: adapter.teadsNativeAd.iconUrl,
                 in: adView.nativeIconImageView?(),
                 respondingToSelector: "nativeIconImageView",
                 withProperty: kAdIconImageKey)

        // Main image
        register(asset: adapter.teadsNativeAd.imageUrl,
                 in: adView.nativeMainImageView?(),
                 respondingToSelector: "nativeMainImageView",
                 withProperty: kAdMainImageKey)

        // Advertiser
        register(asset: adapter.teadsNativeAd.sponsored,
                 in: adView.nativeSponsoredByCompanyTextLabel?(),
                 respondingToSelector: "nativeSponsoredByCompanyTextLabel",
                 withProperty: kAdSponsoredByCompanyKey)

    }

    func registerContainer() {
        guard let adapter = adapter as? MPAdapterTeadsMediatedNativeAd else {
            return
        }
        if let renderingViewClass = renderingViewClass,
            renderingViewClass.responds(to: Selector("nibForAd")) {
            adView = renderingViewClass.nibForAd?()?.instantiate(withOwner: self, options: nil).first as? UIView
        } else if let renderingViewClass = renderingViewClass as? UIView.Type {
            guard let frame = adViewContainer?.frame else {
                return
            }
            adView = renderingViewClass.init(frame: frame)
            guard let adView = adView else {
                return
            }
            adapter.teadsNativeAd.registerContainer(in: adView)
        }
        adView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func register(asset: TeadsNativeAsset?, in assetView: UIView?, respondingToSelector selectorLabel: String, withProperty property: String) {
        guard let adapter = adapter as? MPAdapterTeadsMediatedNativeAd,
            let adView = adView as? MPNativeAdRendering else {
                return
        }
        if adView.responds(to: Selector(selectorLabel)), let assetView = assetView, let asset = asset {
            adapter.teadsNativeAd.register(asset: asset, in: assetView)
            if let text = adapter.properties[property] as? String {
                if let label = assetView as? UILabel {
                    label.text = text
                } else if let imageView = assetView as? UIImageView {
                    UIImage.loadSync(url: text) { (image) in
                        imageView.image = image
                    }
                }
            }
        }
    }
}
