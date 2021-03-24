//
//  MPAdapterTeadsMediatedNativeAd.swift
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

class MPAdapterTeadsMediatedNativeAd: NSObject, MPNativeAdAdapter {

    weak var delegate: MPNativeAdAdapterDelegate?

    var properties: [AnyHashable: Any] {
        var adProperties = [String: String]()
        if let title = teadsNativeAd.title?.text {
            adProperties[kAdTitleKey] = title
        }
        if let content = teadsNativeAd.content?.text {
            adProperties[kAdTextKey] = content
        }
        if let iconUrl = teadsNativeAd.iconUrl?.url {
            adProperties[kAdIconImageKey] = iconUrl
        }
        if let imageUrl = teadsNativeAd.imageUrl?.url {
            adProperties[kAdMainImageKey] = imageUrl
        }
        if let callToAction = teadsNativeAd.callToAction?.text {
            adProperties[kAdCTATextKey] = callToAction
        }
        if let rating = teadsNativeAd.rating?.text {
            adProperties[kAdStarRatingKey] = rating
        }
        if let advertiser = teadsNativeAd.sponsored?.text {
            adProperties[kAdSponsoredByCompanyKey] = advertiser
        }
        return adProperties
    }

    var defaultActionURL: URL!

    var teadsNativeAd: TeadsNativeAd

    init(teadsNativeAd: TeadsNativeAd) {
        self.teadsNativeAd = teadsNativeAd
        super.init()
        self.teadsNativeAd.delegate = self
    }

    func enableThirdPartyClickTracking() -> Bool {
        return false
    }

}

extension MPAdapterTeadsMediatedNativeAd: TeadsNativeAdDelegate {

    func nativeAdDidRecordAdImpression(_ nativeAd: TeadsNativeAd) {
        delegate?.nativeAdWillLogImpression?(self)
        MPLogEvent.adShowSuccess(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
        MPLogEvent.adDidAppear(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
    }

    func nativeAdDidRecordAdClick(_ nativeAd: TeadsNativeAd) {
        delegate?.nativeAdDidClick?(self)
        MPLogEvent.adTapped(forAdapter: NSStringFromClass(MPAdapterTeadsNative.self))
    }

}
