//
//  TeadsInstanceMediationSettings.h
//  TeadsMoPubAdapter
//
//  Created by athomas on 29/05/2018.
//  Copyright © 2018 Teads. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDKFramework/MoPub.h>)
    #import <MoPubSDKFramework/MoPub.h>
#else
    #import "MPMediationSettingsProtocol.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@class TeadsAdSettings;

/// Class encapsulating MoPub mediation settings for Teads rewarded ads.
@interface TeadsInstanceMediationSettings : NSObject <MPMediationSettingsProtocol>

/// Enable test mode
@property (nonatomic, assign) BOOL debugMode;

/// Disable location reporting
@property (nonatomic, assign) BOOL locationDisabled;

/// Enable light mode for endscreen
@property (nonatomic, assign) BOOL lightEndscreen;

/// Disable media preloading
@property (nonatomic, assign) BOOL mediaPreloadDisabled;

/// Brand safety url
@property (nonatomic, strong) NSString *publisherPageUrl;

// GDPR consent
@property (nonatomic, strong) NSString *consent;

@property (nonatomic, strong) NSString *subjectToGDPR;

@property (nonatomic, assign) BOOL audioSessionIsApplicationManaged;

// MARK: - Helpers

/// Creates an instance of `TeadsAdSettings` configured from mediation settings.
/// - returns: A `TeadsAdSettings` containing settings to configure Teads ads.
- (TeadsAdSettings *)getTeadsAdSettings;

@end

NS_ASSUME_NONNULL_END
