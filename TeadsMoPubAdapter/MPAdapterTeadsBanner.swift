//
//  MPAdapterTeadsBanner.swift
//  TeadsMoPubAdapter
//
//  Created by Gwendal Madouas on 25/11/2019.
//  Copyright © 2019 teads. All rights reserved.
//

import Foundation
import MoPub
import TeadsSDK

@objc public class MPAdapterTeadsBanner: MPBannerCustomEvent {
    // MARK: - Members
    internal var currentBanner: TFACustomAdView?

    // MARK: - MPBannerCustomEvent Overrides
    @objc public override func requestAd(with size: CGSize, customEventInfo info: [AnyHashable: Any]!, adMarkup: String!) {
        // Check PID
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            let error = NSError.from(code: .pidNotFound,
                                     description: "No valid PID has been provided to load Teads banner ad.")
            delegate.bannerCustomEvent(self, didFailToLoadAdWithError: error)
            return
        }

        // Prepare ad settings
        var adSettings: TeadsAdSettings?
        if let extraParameters = localExtras {
            adSettings = try? TeadsAdSettings.instance(fromMopubParameters: extraParameters)
        }

        // Load banner
        let banner = TFACustomAdView(withPid: pid, andDelegate: self)
        banner.addContextInfo(infoKey: TeadsAdSettings.integrationTypeKey, infoValue: TeadsAdSettings.integrationMopub)
        banner.addContextInfo(infoKey: TeadsAdSettings.integrationVersionKey, infoValue: MoPub.sharedInstance().version())
        banner.frame = CGRect(origin: CGPoint.zero, size: size)
        banner.load(teadsAdSettings: adSettings)
        currentBanner = banner
    }
}

// MARK: - TFAAdDelegate Protocol

extension MPAdapterTeadsBanner: TFAAdDelegate {
    public func didUpdateRatio(_ ad: TFAAdView, ratio: CGFloat) {
        //will be implemented soon
    }

    public func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        delegate.bannerCustomEvent(self, didLoadAd: ad)
        delegate.bannerCustomEventWillExpandAd(self)
    }

    public func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        let error = NSError.from(code: .loadingFailure,
                                 description: adFailReason.errorMessage)
        delegate.bannerCustomEvent(self, didFailToLoadAdWithError: error)
    }

    public func adClose(_ ad: TFAAdView, userAction: Bool) {
        delegate.bannerCustomEventDidCollapseAd(self)
    }

    public func adError(_ ad: TFAAdView, errorMessage: String) {
        // Nothing to do (required method)
    }

    public func adBrowserDidOpen(_ ad: TFAAdView) {
        delegate.bannerCustomEventWillBeginAction(self)
    }

    public func adBrowserDidClose(_ ad: TFAAdView) {
        delegate.bannerCustomEventDidFinishAction(self)
    }

    public func adDidOpenFullscreen(_ ad: TFAAdView) {
        // TODO: What to do ?
    }

    public func adDidCloseFullscreen(_ ad: TFAAdView) {
        // TODO: What to do ?
    }

    public func adPlaybackChange(_ ad: TFAAdView, state: TFAAdView.TeadsAdPlaybackState) {
        // TODO: What to do ?
    }

    public func adDidChangeVolume(_ ad: TFAAdView, muted: Bool) {
        // TODO: What to do ?
    }
}
