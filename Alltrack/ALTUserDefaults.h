//
//  ALTUserDefaults.h
//  Alltrack
//
//  Created by Uglješa Erceg on 16.08.17.
//  Copyright © 2017 alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTUserDefaults : NSObject

+ (void)savePushTokenData:(NSData *)pushToken;

+ (void)savePushTokenString:(NSString *)pushToken;

+ (NSData *)getPushTokenData;

+ (NSString *)getPushTokenString;

+ (void)removePushToken;

+ (void)setInstallTracked;

+ (BOOL)getInstallTracked;

+ (void)setGdprForgetMe;

+ (BOOL)getGdprForgetMe;

+ (void)removeGdprForgetMe;

+ (void)saveDeeplinkUrl:(NSURL *)deeplink
           andClickTime:(NSDate *)clickTime;

+ (NSURL *)getDeeplinkUrl;

+ (NSDate *)getDeeplinkClickTime;

+ (void)removeDeeplink;

+ (void)setDisableThirdPartySharing;

+ (BOOL)getDisableThirdPartySharing;

+ (void)removeDisableThirdPartySharing;

+ (void)clearAlltrackStuff;

+ (void)setAdServicesTracked;

+ (BOOL)getAdServicesTracked;

+ (void)saveSkadRegisterCallTimestamp:(NSDate *)callTime;

+ (NSDate *)getSkadRegisterCallTimestamp;

+ (void)setLinkMeChecked;

+ (BOOL)getLinkMeChecked;

+ (void)cacheDeeplinkUrl:(NSURL *)deeplink;

+ (NSURL *)getCachedDeeplinkUrl;

@end
