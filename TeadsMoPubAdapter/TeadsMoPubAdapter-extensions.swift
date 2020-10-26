//
//  MPAdView-extension.swift
//  TeadsMoPubAdapter
//
//  Created by Paul Nicolas on 14/05/2020.
//  Copyright © 2020 teads. All rights reserved.
//

import Foundation
import MoPub
import TeadsSDK

@objc extension MPAdView {
    public func register(teadsAdSettings: TeadsAdSettings) {
        guard let extra = try? teadsAdSettings.toDictionary() else {
            return
        }
        localExtras = extra
    }
}

extension TeadsAdSettings: MPMediationSettingsProtocol {
    @nonobjc internal class func instance(fromMopubParameters dictionary: [AnyHashable: Any]?) throws -> TeadsAdSettings {

        let adSettings = try TeadsAdSettings.instance(from: dictionary ?? Dictionary())
        adSettings.addExtras(TeadsAdSettings.integrationMopub, for: TeadsAdSettings.integrationTypeKey)
        adSettings.addExtras(MoPub.sharedInstance().version(), for: TeadsAdSettings.integrationVersionKey)
        return adSettings
    }
}

@objc extension MPNativeAdRequestTargeting {
    public func register(teadsAdSettings: TeadsAdSettings) {
        guard let extra = try? teadsAdSettings.toDictionary() else {
            return
        }
        localExtras = extra
    }
}

extension CGFloat {
    var positive: CGFloat? {
        return self > 0 ? self : nil
    }
}
