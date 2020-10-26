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

@objc public class MPAdapterTeadsBanner: MPInlineAdAdapter, MPThirdPartyInlineAdAdapter {
    // MARK: - Members
    internal var currentBanner: TFACustomAdView?
    internal var pid: String?

    // MARK: - MPBannerCustomEvent Overrides
    @objc public override func requestAd(with size: CGSize, adapterInfo info: [AnyHashable: Any], adMarkup: String?) {

        // Check PID
        guard let rawPid = info[MPAdapterTeadsConstants.teadsPIDKey] as? String, let pid = Int(rawPid) else {
            let error = NSError.from(code: .pidNotFound,
                                     description: "No valid PID has been provided to load Teads banner ad.")
            logEvent(MPLogEvent.adLoadFailed(forAdapter: className(), error: error))
            delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: error)
            return
        }
        self.pid = rawPid

        let adSize = size.width > 0 ? size : MPAdapterTeadsConstants.bannerSize

        // Prepare ad settings
        let adSettings = try? TeadsAdSettings.instance(fromMopubParameters: localExtras)

        // Load banner
        currentBanner = TFACustomAdView(withPid: pid, andDelegate: self)
        currentBanner?.addContextInfo(infoKey: TeadsAdSettings.integrationTypeKey, infoValue: TeadsAdSettings.integrationMopub)
        currentBanner?.addContextInfo(infoKey: TeadsAdSettings.integrationVersionKey, infoValue: MoPub.sharedInstance().version())
        currentBanner?.frame = CGRect(origin: CGPoint.zero, size: adSize)

        logEvent(MPLogEvent.adLoadAttempt(forAdapter: className(), dspCreativeId: nil, dspName: nil))
        currentBanner?.load(teadsAdSettings: adSettings)
    }

    private func updateRatio(_ ratio: CGFloat) {
        if let width = currentBanner?.superview?.frame.width.positive ?? currentBanner?.frame.width.positive {
            currentBanner?.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: width / ratio))
        }
    }

    private func logEvent(_ event: MPLogEvent) {
        MPLogging.logEvent(event, source: pid, from: Self.self)
    }

    deinit {
        currentBanner?.delegate = nil
    }
}

// MARK: - TFAAdDelegate Protocol

extension MPAdapterTeadsBanner: TFAAdDelegate {
    public func didReceiveAd(_ ad: TFAAdView, adRatio: CGFloat) {
        logEvent(MPLogEvent.adLoadSuccess(forAdapter: className()))
        logEvent(MPLogEvent.adShowAttempt(forAdapter: className()))
        logEvent(MPLogEvent.adShowSuccess(forAdapter: className()))
        delegate?.inlineAdAdapter(self, didLoadAdWithAdView: ad)
        updateRatio(adRatio)
    }

    public func didFailToReceiveAd(_ ad: TFAAdView, adFailReason: AdFailReason) {
        let error = NSError.from(code: .loadingFailure,
                                 description: adFailReason.errorMessage)
        logEvent(MPLogEvent.adLoadFailed(forAdapter: className(), error: error))
        delegate?.inlineAdAdapter(self, didFailToLoadAdWithError: error)
    }

    public func adClose(_ ad: TFAAdView, userAction: Bool) {
        delegate?.inlineAdAdapterDidCollapse(self)
    }

    public func adError(_ ad: TFAAdView, errorMessage: String) {
        // Nothing to do (required method)
    }

    public func adBrowserDidOpen(_ ad: TFAAdView) {
        delegate?.inlineAdAdapterWillBeginUserAction(self)
    }

    public func adBrowserDidClose(_ ad: TFAAdView) {
        delegate?.inlineAdAdapterDidEndUserAction(self)
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

    public func didUpdateRatio(_ ad: TFAAdView, ratio: CGFloat) {
        updateRatio(ratio)
    }

    public func adBrowserWillOpen(_ ad: TFAAdView) -> UIViewController? {
        logEvent(MPLogEvent.adWillPresentModal(forAdapter: className()))
        return delegate?.inlineAdAdapterViewController(forPresentingModalView: self)
    }
}
