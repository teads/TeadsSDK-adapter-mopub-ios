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

typealias TeadsUIViewMPNativeAdRendering = UIView & MPNativeAdRendering

@objc public class MPAdapterTeadsNativeAdRenderer: NSObject, MPNativeAdRenderer {

    @objc public var viewSizeHandler: MPNativeViewSizeHandler!

    var rendererSettings: MPAdapterTeadsNativeAdRendererSettings!

    var adViewContainer: UIView?

    /// Publisher adView which is rendering.
    var adView: TeadsUIViewMPNativeAdRendering?

    /// YES if adView is in view hierarchy.
    var adViewInViewHierarchy: Bool?

    /// MPNativeAdRendererImageHandler instance.
    var renderingViewClass: TeadsUIViewMPNativeAdRendering.Type?

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

        renderTeadsNativeAdView(with: adapter)

        guard let adView = adView else {
            throw MPNativeAdNSErrorForRenderValueTypeError()
        }
        return adView
    }

    /// Creates Teads Native AdView with adapter. We added TeadsNativeAdView assets on
    /// top of MoPub's adView, to track impressions & clicks.
    func renderTeadsNativeAdView(with adapter: MPAdapterTeadsMediatedNativeAd) {

        registerContainer(adapter: adapter)
        guard let adView = adView else {
            return
        }

        // Title
        register(asset: adapter.teadsNativeAd.title,
                 in: adView.nativeTitleTextLabel?(),
                 withProperty: kAdTitleKey,
                 adapter: adapter)

        // Main Text
        register(asset: adapter.teadsNativeAd.content,
                 in: adView.nativeMainTextLabel?(),
                 withProperty: kAdTextKey,
                 adapter: adapter)

        // Call to action
        register(asset: adapter.teadsNativeAd.callToAction,
                 in: adView.nativeCallToActionTextLabel?(),
                 withProperty: kAdCTATextKey,
                 adapter: adapter)

        // Icon image
        register(asset: adapter.teadsNativeAd.iconUrl,
                 in: adView.nativeIconImageView?(),
                 withProperty: kAdIconImageKey,
                 adapter: adapter)

        // Main image
        register(asset: adapter.teadsNativeAd.imageUrl,
                 in: adView.nativeMainImageView?(),
                 withProperty: kAdMainImageKey,
                 adapter: adapter)

        // Advertiser
        register(asset: adapter.teadsNativeAd.sponsored,
                 in: adView.nativeSponsoredByCompanyTextLabel?(),
                 withProperty: kAdSponsoredByCompanyKey,
                 adapter: adapter)

    }

    func registerContainer(adapter: MPAdapterTeadsMediatedNativeAd) {
        guard let adViewContainerFrame = adViewContainer?.frame else {
            return
        }
        if let adView = renderingViewClass?.nibForAd?()?.instantiate(withOwner: self, options: nil).first as? TeadsUIViewMPNativeAdRendering {
            self.adView = adView
        } else {
            adView = renderingViewClass?.init(frame: adViewContainerFrame)
        }
        guard let adView = adView else {
            return
        }
        adView.frame = adViewContainerFrame
        adView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        adapter.teadsNativeAd.registerContainer(in: adView)
    }

    func register(asset: TeadsNativeAsset?, in assetView: UIView?, withProperty property: String, adapter: MPAdapterTeadsMediatedNativeAd) {
        if let assetView = assetView, let asset = asset {
            adapter.teadsNativeAd.register(asset: asset, in: assetView)
            if let text = adapter.properties[property] as? String {
                if let label = assetView as? UILabel {
                    label.text = text
                } else if let imageView = assetView as? UIImageView, let imageAsset = asset as? TeadsNativeImageAsset {
                    imageAsset.loadImage(success: { image in
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    })
                }
            }
        }
    }
}
