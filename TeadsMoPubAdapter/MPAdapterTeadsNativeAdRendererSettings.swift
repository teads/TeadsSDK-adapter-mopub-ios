//
//  MPAdapterTeadsNativeAdRendererSettings.swift
//  TeadsMoPubAdapter
//
//  Created by Thibaud Saint-Etienne on 11/06/2020.
//  Copyright © 2020 teads. All rights reserved.
//

import MoPub

@objc public class MPAdapterTeadsNativeAdRendererSettings: NSObject, MPNativeAdRendererSettings {
    @objc public var viewSizeHandler: MPNativeViewSizeHandler!
    @objc public var renderingViewClass: (UIView & MPNativeAdRendering).Type?
    @objc public var adViewContainer: UIView?
}
