//
//  MPAdapterTeadsNative.swift
//  TeadsMoPubAdapter
//
//  Created by Thibaud Saint-Etienne on 09/06/2020.
//  Copyright © 2020 teads. All rights reserved.
//

import UIKit
import TeadsSDK

#if canImport(MoPubSDK)
import MoPubSDK
#else
import MoPub
#endif

@objc public class MPAdapterTeadsNative: MPNativeCustomEvent {

    // MARK: - Members
    private var currentNative: TeadsAdPlacement?
    private var mediatedNativeAd: MPNativeAdAdapter?

    // MARK: - MPNativeCustomEvent Protocol
    @objc public override func requestAd(withCustomEventInfo info: [AnyHashable: Any]!, adMarkup: String!) {
        // Check PID
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            let error = NSError.from(code: .pidNotFound,
                                     description: "No valid PID has been provided to load Teads banner ad.")
            delegate.nativeCustomEvent(self, didFailToLoadAdWithError: error)
            return
        }

        // Prepare ad settings
        var adSettings: TeadsAdSettings?
        adSettings = try? TeadsAdSettings.instance(fromMopubParameters: localExtras)

        // Load native ad
        currentNative = TeadsAdPlacement(placementId: pid, delegate: self)
        currentNative?.requestAd(TeadsNativeAdRequest(template: .mopub, settings: adSettings))
    }

}

extension MPAdapterTeadsNative: TeadsAdPlacementDelegate {
    public func adPlacement(_ adPlacement: TeadsAdPlacement, didReceiveNativeAd nativeAd: TeadsNativeAd) {
        // Bind the mediated Teads ad with mopub
        mediatedNativeAd = MPAdapterTeadsMediatedNativeAd(teadsNativeAd: nativeAd)
        guard let mediatedNativeAd = mediatedNativeAd else {
            return
        }
        let nativeAd = MPNativeAd(adAdapter: mediatedNativeAd)
        delegate.nativeCustomEvent(self, didLoad: nativeAd)
    }

    public func adPlacement(_ adPlacement: TeadsAdPlacement, didFailToReceiveAd adFailReason: AdFailReason) {
        delegate.nativeCustomEvent(self, didFailToLoadAdWithError: NSError(domain: "teads.placement", code: adFailReason.errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: adFailReason.errorMessage]))
    }
}
