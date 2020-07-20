//
//  MPAdapterTeadsInterstitial.swift
//  TeadsMoPubAdapter
//
//  Created by Gwendal Madouas on 25/11/2019.
//  Copyright © 2019 teads. All rights reserved.
//

import Foundation
import TeadsSDK

import MoPub

@objc public class MPAdapterTeadsInterstitial: MPInterstitialCustomEvent {

    // MARK: - Members
    private var currentInterstitial: TFAInterstitialAd?

    // MARK: - MPInterstitialCustomEvent Overrides
    @objc override public func requestInterstitial(withCustomEventInfo info: [AnyHashable: Any]!, adMarkup: String!) {

        // Check PID
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            let error = NSError.from(code: .pidNotFound,
                                     description: "No valid PID has been provided to load Teads interstitial ad.")
            delegate?.interstitialCustomEvent(self, didFailToLoadAdWithError: error)
            return
        }

        var adSettings: TeadsAdSettings?
        adSettings = try? TeadsAdSettings.instance(fromMopubParameters: localExtras)

        // Load interstitial
        let interstitial = TFAInterstitialAd(withPid: pid, andDelegate: self)
        interstitial.addContextInfo(infoKey: TeadsAdSettings.integrationTypeKey, infoValue: TeadsAdSettings.integrationMopub)
        interstitial.addContextInfo(infoKey: TeadsAdSettings.integrationVersionKey, infoValue: MoPub.sharedInstance().version())
        interstitial.load(settings: adSettings)
        currentInterstitial = interstitial
    }
}

// MARK: - TFAInterstitialAdDelegate Protocol

extension MPAdapterTeadsInterstitial: TFAInterstitialAdDelegate {
    public func interstitialDidReceiveAd(_ ad: TFAInterstitialAd) {
        delegate?.interstitialCustomEvent(self, didLoadAd: ad)
    }

    public func interstitial(_ ad: TFAInterstitialAd, didFailToReceiveAdWithError error: String) {
        let error = NSError.from(code: .loadingFailure,
                                 description: error)
        self.delegate?.interstitialCustomEvent(self, didFailToLoadAdWithError: error)
    }

    public func interstitialWillOpen(_ ad: TFAInterstitialAd) {
        delegate?.interstitialCustomEventWillAppear(self)
    }

    public func interstitialWillClose(_ ad: TFAInterstitialAd) {
        delegate?.interstitialCustomEventWillDisappear(self)
    }

    public func interstitialDidOpen(_ ad: TFAInterstitialAd) {
        delegate?.interstitialCustomEventDidAppear(self)
    }

    public func interstitialDidClose(_ ad: TFAInterstitialAd) {
        delegate?.interstitialCustomEventDidDisappear(self)
    }

    public func interstitialBrowserDidOpen(_ ad: TFAInterstitialAd) {
        delegate?.interstitialCustomEventDidReceiveTap(self)
    }

    public func interstitialBrowserDidClose(_ ad: TFAInterstitialAd) {
        // TODO: What to do ?
    }

    public func interstitialWillLeaveApplication(_ ad: TFAInterstitialAd) {
        delegate?.interstitialCustomEventWillLeaveApplication(self)
    }
}
