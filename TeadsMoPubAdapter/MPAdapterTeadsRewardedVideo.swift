//
//  MPAdapterTeadsRewardedVideo.swift
//  TeadsMoPubAdapter
//
//  Created by Gwendal Madouas on 25/11/2019.
//  Copyright © 2019 teads. All rights reserved.
//

import Foundation
import TeadsSDK
import MoPub

@objc public class MPAdapterTeadsRewardedVideo: MPRewardedVideoCustomEvent {
    // MARK: - Members

    private var currentRewardedVideo: TFARewardedAd?
    private var isVideoLoaded = false

    // MARK: - MPRewardedVideoCustomEvent Overrides
    @objc public override func requestRewardedVideo(withCustomEventInfo info: [AnyHashable: Any]!, adMarkup: String!) {

        // Check PID
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            let error = NSError.from(code: .pidNotFound,
                                     description: "No valid PID has been provided to load rewarded ad.")
            delegate.rewardedVideoDidFailToLoadAd(for: self, error: error)
            return
        }

        // Prepare ad settings
        var adSettings: TeadsAdSettings?
        if let settings = delegate.instanceMediationSettings(for: TeadsAdSettings.self) as? TeadsAdSettings {
            adSettings = settings
            adSettings?.addExtras(TeadsAdSettings.integrationMopub, for: TeadsAdSettings.integrationTypeKey)
            adSettings?.addExtras(MoPub.sharedInstance().version(), for: TeadsAdSettings.integrationVersionKey)
        } else {
            adSettings = try? TeadsAdSettings.instance(fromMopubParameters: localExtras)
        }

        // Load rewarded ad
        let rewardedVideo = TFARewardedAd(withPid: pid, andDelegate: self)
        rewardedVideo.addContextInfo(infoKey: TeadsAdSettings.integrationTypeKey, infoValue: TeadsAdSettings.integrationMopub)
        rewardedVideo.addContextInfo(infoKey: TeadsAdSettings.integrationVersionKey, infoValue: MoPub.sharedInstance().version())
        rewardedVideo.load(settings: adSettings)
        currentRewardedVideo = rewardedVideo
    }

    @objc override public func hasAdAvailable() -> Bool {
        if currentRewardedVideo != nil {
            return isVideoLoaded
        }
        return false
    }

    @objc public override func presentRewardedVideo(from viewController: UIViewController!) {
        currentRewardedVideo?.show()
    }

    @objc public override func handleInvalidated() {
        currentRewardedVideo?.delegate = nil
        currentRewardedVideo = nil
        isVideoLoaded = false
    }
}

// MARK: - TFARewardedAdDelegate Protocol

extension MPAdapterTeadsRewardedVideo: TFARewardedAdDelegate {

    public func rewardedAdDidReceive(_ rewardedAd: TFARewardedAd) {
        isVideoLoaded = true
        delegate.rewardedVideoDidLoadAd(for: self)
    }

    public func rewarded(_ rewardedAd: TFARewardedAd, didFailToReceiveAdWithError: String) {
        isVideoLoaded = false
        let error = NSError.from(code: .loadingFailure,
                                 description: didFailToReceiveAdWithError)
        delegate.rewardedVideoDidFailToLoadAd(for: self, error: error)
    }

    public func rewarded(_ rewardedAd: TFARewardedAd, didRewardUserWith reward: TFAReward?) {
        guard let reward = reward else { return }

        let amount = NSDecimalNumber(value: reward.amount)
        let adReward = MPRewardedVideoReward(currencyType: reward.type ?? "", amount: amount)
        delegate.rewardedVideoShouldRewardUser(for: self, reward: adReward)
    }

    public func rewardedAdDidOpen(_ rewardedAd: TFARewardedAd) {
        delegate.rewardedVideoWillAppear(for: self)
        delegate.rewardedVideoDidAppear(for: self)
    }

    public func rewardedAdDidStartPlaying(_ rewardedAd: TFARewardedAd) {
        // TODO: what to do ?
    }

    public func rewardedAdDidCompletePlaying(_ rewardedAd: TFARewardedAd) {
        // TODO: what to do ?
    }

    public func rewardedAdWillLeaveApplication(_ rewardedAd: TFARewardedAd) {
        delegate.rewardedVideoWillLeaveApplication(for: self)
    }

    public func rewardedAdDidClose(_ rewardedAd: TFARewardedAd) {
        delegate.rewardedVideoWillDisappear(for: self)
        delegate.rewardedVideoDidDisappear(for: self)
        currentRewardedVideo?.delegate = nil
        currentRewardedVideo = nil
        isVideoLoaded = false
    }

    public func rewardedAdBrowserDidOpen(_ rewardedAd: TFARewardedAd) {
        delegate.rewardedVideoDidReceiveTapEvent(for: self)
    }
}
