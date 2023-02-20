//
//  AlltrackBridge.m
//  Alltrack SDK
//
//  Created by Pedro Filipe (@nonelse) on 27th April 2016.
//  Copyright © 2016-2018 Alltrack GmbH. All rights reserved.
//

#import "Alltrack.h"
// In case of erroneous import statement try with:
// #import <AlltrackSdk/Alltrack.h>
// (depends how you import the Alltrack SDK to your app)

#import "AlltrackBridge.h"
#import "ALTAlltrackFactory.h"
#import "WKWebViewJavascriptBridge.h"

@interface AlltrackBridge() <AlltrackDelegate>

@property BOOL openDeferredDeeplink;
@property (nonatomic, copy) NSString *fbPixelDefaultEventToken;
@property (nonatomic, copy) NSString *attributionCallbackName;
@property (nonatomic, copy) NSString *eventSuccessCallbackName;
@property (nonatomic, copy) NSString *eventFailureCallbackName;
@property (nonatomic, copy) NSString *sessionSuccessCallbackName;
@property (nonatomic, copy) NSString *sessionFailureCallbackName;
@property (nonatomic, copy) NSString *deferredDeeplinkCallbackName;
@property (nonatomic, strong) NSMutableDictionary *fbPixelMapping;

@end

@implementation AlltrackBridge

#pragma mark - Object lifecycle

- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _bridgeRegister = nil;
    [self resetAlltrackBridge];
    return self;
}

- (void)resetAlltrackBridge {
    self.attributionCallbackName = nil;
    self.eventSuccessCallbackName = nil;
    self.eventFailureCallbackName = nil;
    self.sessionSuccessCallbackName = nil;
    self.sessionFailureCallbackName = nil;
    self.deferredDeeplinkCallbackName = nil;
}

#pragma mark - AlltrackDelegate methods

- (void)alltrackAttributionChanged:(ALTAttribution *)attribution {
    if (self.attributionCallbackName == nil) {
        return;
    }
    [self.bridgeRegister callHandler:self.attributionCallbackName data:[attribution dictionary]];
}

- (void)alltrackEventTrackingSucceeded:(ALTEventSuccess *)eventSuccessResponseData {
    if (self.eventSuccessCallbackName == nil) {
        return;
    }

    NSMutableDictionary *eventSuccessResponseDataDictionary = [NSMutableDictionary dictionary];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.message forKey:@"message"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.timeStamp forKey:@"timestamp"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.adid forKey:@"adid"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.eventToken forKey:@"eventToken"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.callbackId forKey:@"callbackId"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:eventSuccessResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [eventSuccessResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.eventSuccessCallbackName data:eventSuccessResponseDataDictionary];
}

- (void)alltrackEventTrackingFailed:(ALTEventFailure *)eventFailureResponseData {
    if (self.eventFailureCallbackName == nil) {
        return;
    }

    NSMutableDictionary *eventFailureResponseDataDictionary = [NSMutableDictionary dictionary];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.message forKey:@"message"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.timeStamp forKey:@"timestamp"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.adid forKey:@"adid"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.eventToken forKey:@"eventToken"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.callbackId forKey:@"callbackId"];
    [eventFailureResponseDataDictionary setValue:[NSNumber numberWithBool:eventFailureResponseData.willRetry] forKey:@"willRetry"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:eventFailureResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [eventFailureResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.eventFailureCallbackName data:eventFailureResponseDataDictionary];
}

- (void)alltrackSessionTrackingSucceeded:(ALTSessionSuccess *)sessionSuccessResponseData {
    if (self.sessionSuccessCallbackName == nil) {
        return;
    }

    NSMutableDictionary *sessionSuccessResponseDataDictionary = [NSMutableDictionary dictionary];
    [sessionSuccessResponseDataDictionary setValue:sessionSuccessResponseData.message forKey:@"message"];
    [sessionSuccessResponseDataDictionary setValue:sessionSuccessResponseData.timeStamp forKey:@"timestamp"];
    [sessionSuccessResponseDataDictionary setValue:sessionSuccessResponseData.adid forKey:@"adid"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:sessionSuccessResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [sessionSuccessResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.sessionSuccessCallbackName data:sessionSuccessResponseDataDictionary];
}

- (void)alltrackSessionTrackingFailed:(ALTSessionFailure *)sessionFailureResponseData {
    if (self.sessionFailureCallbackName == nil) {
        return;
    }

    NSMutableDictionary *sessionFailureResponseDataDictionary = [NSMutableDictionary dictionary];
    [sessionFailureResponseDataDictionary setValue:sessionFailureResponseData.message forKey:@"message"];
    [sessionFailureResponseDataDictionary setValue:sessionFailureResponseData.timeStamp forKey:@"timestamp"];
    [sessionFailureResponseDataDictionary setValue:sessionFailureResponseData.adid forKey:@"adid"];
    [sessionFailureResponseDataDictionary setValue:[NSNumber numberWithBool:sessionFailureResponseData.willRetry] forKey:@"willRetry"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:sessionFailureResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [sessionFailureResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.sessionFailureCallbackName data:sessionFailureResponseDataDictionary];
}

- (BOOL)alltrackDeeplinkResponse:(NSURL *)deeplink {
    if (self.deferredDeeplinkCallbackName) {
        [self.bridgeRegister callHandler:self.deferredDeeplinkCallbackName data:[deeplink absoluteString]];
    }
    return self.openDeferredDeeplink;
}

#pragma mark - Public methods

- (void)augmentHybridWebView {
    NSString *fbAppId = [self getFbAppId];

    if (fbAppId == nil) {
        [[ALTAlltrackFactory logger] error:@"FacebookAppID is not correctly configured in the pList"];
        return;
    }
    [_bridgeRegister augmentHybridWebView:fbAppId];
    [self registerAugmentedView];
}

- (void)loadWKWebViewBridge:(WKWebView *)wkWebView {
    [self loadWKWebViewBridge:wkWebView wkWebViewDelegate:nil];
}

- (void)loadWKWebViewBridge:(WKWebView *)wkWebView
          wkWebViewDelegate:(id<WKNavigationDelegate>)wkWebViewDelegate {
    if (self.bridgeRegister != nil) {
        // WebViewBridge already loaded.
        return;
    }

    _bridgeRegister = [[AlltrackBridgeRegister alloc] initWithWKWebView:wkWebView];
    [self.bridgeRegister setWKWebViewDelegate:wkWebViewDelegate];

    [self.bridgeRegister registerHandler:@"alltrack_appDidLaunch" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *appToken = [data objectForKey:@"appToken"];
        NSString *environment = [data objectForKey:@"environment"];
        NSString *allowSuppressLogLevel = [data objectForKey:@"allowSuppressLogLevel"];
        NSString *sdkPrefix = [data objectForKey:@"sdkPrefix"];
        NSString *defaultTracker = [data objectForKey:@"defaultTracker"];
        NSString *externalDeviceId = [data objectForKey:@"externalDeviceId"];
        NSString *logLevel = [data objectForKey:@"logLevel"];
        NSNumber *eventBufferingEnabled = [data objectForKey:@"eventBufferingEnabled"];
        NSNumber *coppaCompliantEnabled = [data objectForKey:@"coppaCompliantEnabled"];
        NSNumber *linkMeEnabled = [data objectForKey:@"linkMeEnabled"];
        NSNumber *sendInBackground = [data objectForKey:@"sendInBackground"];
        NSNumber *delayStart = [data objectForKey:@"delayStart"];
        NSString *userAgent = [data objectForKey:@"userAgent"];
        NSNumber *isDeviceKnown = [data objectForKey:@"isDeviceKnown"];
        NSNumber *needsCost = [data objectForKey:@"needsCost"];
        NSNumber *allowAdServicesInfoReading = [data objectForKey:@"allowAdServicesInfoReading"];
        NSNumber *allowIdfaReading = [data objectForKey:@"allowIdfaReading"];
        NSNumber *allowSkAdNetworkHandling = [data objectForKey:@"allowSkAdNetworkHandling"];
        NSNumber *secretId = [data objectForKey:@"secretId"];
        NSString *info1 = [data objectForKey:@"info1"];
        NSString *info2 = [data objectForKey:@"info2"];
        NSString *info3 = [data objectForKey:@"info3"];
        NSString *info4 = [data objectForKey:@"info4"];
        NSNumber *openDeferredDeeplink = [data objectForKey:@"openDeferredDeeplink"];
        NSString *fbPixelDefaultEventToken = [data objectForKey:@"fbPixelDefaultEventToken"];
        id fbPixelMapping = [data objectForKey:@"fbPixelMapping"];
        NSString *attributionCallback = [data objectForKey:@"attributionCallback"];
        NSString *eventSuccessCallback = [data objectForKey:@"eventSuccessCallback"];
        NSString *eventFailureCallback = [data objectForKey:@"eventFailureCallback"];
        NSString *sessionSuccessCallback = [data objectForKey:@"sessionSuccessCallback"];
        NSString *sessionFailureCallback = [data objectForKey:@"sessionFailureCallback"];
        NSString *deferredDeeplinkCallback = [data objectForKey:@"deferredDeeplinkCallback"];
        NSString *urlStrategy = [data objectForKey:@"urlStrategy"];

        ALTConfig *alltrackConfig;
        if ([self isFieldValid:allowSuppressLogLevel]) {
            alltrackConfig = [ALTConfig configWithAppToken:appToken environment:environment allowSuppressLogLevel:[allowSuppressLogLevel boolValue]];
        } else {
            alltrackConfig = [ALTConfig configWithAppToken:appToken environment:environment];
        }

        // No need to continue if alltrack config is not valid.
        if (![alltrackConfig isValid]) {
            return;
        }

        if ([self isFieldValid:sdkPrefix]) {
            [alltrackConfig setSdkPrefix:sdkPrefix];
        }
        if ([self isFieldValid:defaultTracker]) {
            [alltrackConfig setDefaultTracker:defaultTracker];
        }
        if ([self isFieldValid:externalDeviceId]) {
            [alltrackConfig setExternalDeviceId:externalDeviceId];
        }
        if ([self isFieldValid:logLevel]) {
            [alltrackConfig setLogLevel:[ALTLogger logLevelFromString:[logLevel lowercaseString]]];
        }
        if ([self isFieldValid:eventBufferingEnabled]) {
            [alltrackConfig setEventBufferingEnabled:[eventBufferingEnabled boolValue]];
        }
        if ([self isFieldValid:coppaCompliantEnabled]) {
            [alltrackConfig setCoppaCompliantEnabled:[coppaCompliantEnabled boolValue]];
        }
        if ([self isFieldValid:linkMeEnabled]) {
            [alltrackConfig setLinkMeEnabled:[linkMeEnabled boolValue]];
        }
        if ([self isFieldValid:sendInBackground]) {
            [alltrackConfig setSendInBackground:[sendInBackground boolValue]];
        }
        if ([self isFieldValid:delayStart]) {
            [alltrackConfig setDelayStart:[delayStart doubleValue]];
        }
        if ([self isFieldValid:userAgent]) {
            [alltrackConfig setUserAgent:userAgent];
        }
        if ([self isFieldValid:isDeviceKnown]) {
            [alltrackConfig setIsDeviceKnown:[isDeviceKnown boolValue]];
        }
        if ([self isFieldValid:needsCost]) {
            [alltrackConfig setNeedsCost:[needsCost boolValue]];
        }
        if ([self isFieldValid:allowAdServicesInfoReading]) {
            [alltrackConfig setAllowAdServicesInfoReading:[allowAdServicesInfoReading boolValue]];
        }
        if ([self isFieldValid:allowIdfaReading]) {
            [alltrackConfig setAllowIdfaReading:[allowIdfaReading boolValue]];
        }
        if ([self isFieldValid:allowSkAdNetworkHandling]) {
            if ([allowSkAdNetworkHandling boolValue] == NO) {
                [alltrackConfig deactivateSKAdNetworkHandling];
            }
        }
        BOOL isAppSecretDefined = [self isFieldValid:secretId]
        && [self isFieldValid:info1]
        && [self isFieldValid:info2]
        && [self isFieldValid:info3]
        && [self isFieldValid:info4];
        if (isAppSecretDefined) {
            [alltrackConfig setAppSecret:[[self fieldToNSNumber:secretId] unsignedIntegerValue]
                                 info1:[[self fieldToNSNumber:info1] unsignedIntegerValue]
                                 info2:[[self fieldToNSNumber:info2] unsignedIntegerValue]
                                 info3:[[self fieldToNSNumber:info3] unsignedIntegerValue]
                                 info4:[[self fieldToNSNumber:info4] unsignedIntegerValue]];
        }
        if ([self isFieldValid:openDeferredDeeplink]) {
            self.openDeferredDeeplink = [openDeferredDeeplink boolValue];
        }
        if ([self isFieldValid:fbPixelDefaultEventToken]) {
            self.fbPixelDefaultEventToken = fbPixelDefaultEventToken;
        }
        if ([fbPixelMapping count] > 0) {
            self.fbPixelMapping = [[NSMutableDictionary alloc] initWithCapacity:[fbPixelMapping count] / 2];
        }
        for (int i = 0; i < [fbPixelMapping count]; i += 2) {
            NSString *key = [[fbPixelMapping objectAtIndex:i] description];
            NSString *value = [[fbPixelMapping objectAtIndex:(i + 1)] description];
            [self.fbPixelMapping setObject:value forKey:key];
        }
        if ([self isFieldValid:attributionCallback]) {
            self.attributionCallbackName = attributionCallback;
        }
        if ([self isFieldValid:eventSuccessCallback]) {
            self.eventSuccessCallbackName = eventSuccessCallback;
        }
        if ([self isFieldValid:eventFailureCallback]) {
            self.eventFailureCallbackName = eventFailureCallback;
        }
        if ([self isFieldValid:sessionSuccessCallback]) {
            self.sessionSuccessCallbackName = sessionSuccessCallback;
        }
        if ([self isFieldValid:sessionFailureCallback]) {
            self.sessionFailureCallbackName = sessionFailureCallback;
        }
        if ([self isFieldValid:deferredDeeplinkCallback]) {
            self.deferredDeeplinkCallbackName = deferredDeeplinkCallback;
        }

        // Set self as delegate if any callback is configured.
        // Change to swizzle the methods in the future.
        if (self.attributionCallbackName != nil
            || self.eventSuccessCallbackName != nil
            || self.eventFailureCallbackName != nil
            || self.sessionSuccessCallbackName != nil
            || self.sessionFailureCallbackName != nil
            || self.deferredDeeplinkCallbackName != nil) {
            [alltrackConfig setDelegate:self];
        }
        if ([self isFieldValid:urlStrategy]) {
            [alltrackConfig setUrlStrategy:urlStrategy];
        }

        [Alltrack appDidLaunch:alltrackConfig];
        [Alltrack trackSubsessionStart];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_trackEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *eventToken = [data objectForKey:@"eventToken"];
        NSString *revenue = [data objectForKey:@"revenue"];
        NSString *currency = [data objectForKey:@"currency"];
        NSString *transactionId = [data objectForKey:@"transactionId"];
        id callbackParameters = [data objectForKey:@"callbackParameters"];
        id partnerParameters = [data objectForKey:@"partnerParameters"];
        NSString *callbackId = [data objectForKey:@"callbackId"];

        ALTEvent *alltrackEvent = [ALTEvent eventWithEventToken:eventToken];
        // No need to continue if alltrack event is not valid
        if (![alltrackEvent isValid]) {
            return;
        }

        if ([self isFieldValid:revenue] && [self isFieldValid:currency]) {
            double revenueValue = [revenue doubleValue];
            [alltrackEvent setRevenue:revenueValue currency:currency];
        }
        if ([self isFieldValid:transactionId]) {
            [alltrackEvent setTransactionId:transactionId];
        }
        for (int i = 0; i < [callbackParameters count]; i += 2) {
            NSString *key = [[callbackParameters objectAtIndex:i] description];
            NSString *value = [[callbackParameters objectAtIndex:(i + 1)] description];
            [alltrackEvent addCallbackParameter:key value:value];
        }
        for (int i = 0; i < [partnerParameters count]; i += 2) {
            NSString *key = [[partnerParameters objectAtIndex:i] description];
            NSString *value = [[partnerParameters objectAtIndex:(i + 1)] description];
            [alltrackEvent addPartnerParameter:key value:value];
        }
        if ([self isFieldValid:callbackId]) {
            [alltrackEvent setCallbackId:callbackId];
        }

        [Alltrack trackEvent:alltrackEvent];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_trackSubsessionStart" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack trackSubsessionStart];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_trackSubsessionEnd" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack trackSubsessionEnd];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_setEnabled" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSNumber class]]) {
            return;
        }
        [Alltrack setEnabled:[(NSNumber *)data boolValue]];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_isEnabled" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        responseCallback([NSNumber numberWithBool:[Alltrack isEnabled]]);
    }];

    [self.bridgeRegister registerHandler:@"alltrack_appWillOpenUrl" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack appWillOpenUrl:[NSURL URLWithString:data]];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_setDeviceToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSString class]]) {
            return;
        }
        [Alltrack setPushToken:(NSString *)data];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_setOfflineMode" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSNumber class]]) {
            return;
        }
        [Alltrack setOfflineMode:[(NSNumber *)data boolValue]];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_sdkVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }

        NSString *sdkPrefix = (NSString *)data;
        NSString *sdkVersion = [NSString stringWithFormat:@"%@@%@", sdkPrefix, [Alltrack sdkVersion]];
        responseCallback(sdkVersion);
    }];
    
    [self.bridgeRegister registerHandler:@"alltrack_idfa" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        responseCallback([Alltrack idfa]);
    }];
    
    [self.bridgeRegister registerHandler:@"alltrack_requestTrackingAuthorizationWithCompletionHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        
        [Alltrack requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
            responseCallback([NSNumber numberWithUnsignedInteger:status]);
        }];
    }];
    
    [self.bridgeRegister registerHandler:@"alltrack_appTrackingAuthorizationStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        
        responseCallback([NSNumber numberWithInt:[Alltrack appTrackingAuthorizationStatus]]);
    }];
    
    [self.bridgeRegister registerHandler:@"alltrack_updateConversionValue" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSNumber class]]) {
            return;
        }
        [Alltrack updateConversionValue:[(NSNumber *)data integerValue]];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_updateConversionValueCompletionHandler"
                                 handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSNumber class]]) {
            return;
        }
        [Alltrack updatePostbackConversionValue:[(NSNumber *)data integerValue]
                            completionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                responseCallback([NSString stringWithFormat:@"%@", error]);
            }
        }];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_updateConversionValueCoarseValueCompletionHandler"
                                 handler:^(id data, WVJBResponseCallback responseCallback) {
        NSNumber *conversionValue = [data objectForKey:@"conversionValue"];
        NSString *coarseValue = [data objectForKey:@"coarseValue"];
        [Alltrack updatePostbackConversionValue:[conversionValue integerValue]
                                  coarseValue:coarseValue
                            completionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                responseCallback([NSString stringWithFormat:@"%@", error]);
            }
        }];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_updateConversionValueCoarseValueLockWindowCompletionHandler"
                                 handler:^(id data, WVJBResponseCallback responseCallback) {
        NSNumber *conversionValue = [data objectForKey:@"conversionValue"];
        NSString *coarseValue = [data objectForKey:@"coarseValue"];
        NSNumber *lockWindow = [data objectForKey:@"lockWindow"];
        [Alltrack updatePostbackConversionValue:[conversionValue integerValue]
                                  coarseValue:coarseValue
                                   lockWindow:[lockWindow boolValue]
                            completionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                responseCallback([NSString stringWithFormat:@"%@", error]);
            }
        }];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_adid" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        responseCallback([Alltrack adid]);
    }];

    [self.bridgeRegister registerHandler:@"alltrack_attribution" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }

        ALTAttribution *attribution = [Alltrack attribution];
        NSDictionary *attributionDictionary = nil;
        if (attribution != nil) {
            attributionDictionary = [attribution dictionary];
        }

        responseCallback(attributionDictionary);
    }];

    [self.bridgeRegister registerHandler:@"alltrack_sendFirstPackages" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack sendFirstPackages];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_addSessionCallbackParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *key = [data objectForKey:@"key"];
        NSString *value = [data objectForKey:@"value"];
        [Alltrack addSessionCallbackParameter:key value:value];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_addSessionPartnerParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *key = [data objectForKey:@"key"];
        NSString *value = [data objectForKey:@"value"];
        [Alltrack addSessionPartnerParameter:key value:value];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_removeSessionCallbackParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSString class]]) {
            return;
        }
        [Alltrack removeSessionCallbackParameter:(NSString *)data];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_removeSessionPartnerParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSString class]]) {
            return;
        }
        [Alltrack removeSessionPartnerParameter:(NSString *)data];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_resetSessionCallbackParameters" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack resetSessionCallbackParameters];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_resetSessionPartnerParameters" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack resetSessionPartnerParameters];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_gdprForgetMe" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack gdprForgetMe];
    }];
    
    [self.bridgeRegister registerHandler:@"alltrack_trackAdRevenue" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *source = [data objectForKey:@"source"];
        NSString *payload = [data objectForKey:@"payload"];
        NSData *dataPayload = [payload dataUsingEncoding:NSUTF8StringEncoding];
        [Alltrack trackAdRevenue:source payload:dataPayload];
    }];
    
    [self.bridgeRegister registerHandler:@"alltrack_disableThirdPartySharing" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack disableThirdPartySharing];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_trackThirdPartySharing" handler:^(id data, WVJBResponseCallback responseCallback) {
        id isEnabledO = [data objectForKey:@"isEnabled"];
        id granularOptions = [data objectForKey:@"granularOptions"];
        id partnerSharingSettings = [data objectForKey:@"partnerSharingSettings"];

        NSNumber *isEnabled = nil;
        if ([isEnabledO isKindOfClass:[NSNumber class]]) {
            isEnabled = (NSNumber *)isEnabledO;
        }
        ALTThirdPartySharing *alltrackThirdPartySharing =
            [[ALTThirdPartySharing alloc] initWithIsEnabledNumberBool:isEnabled];
        for (int i = 0; i < [granularOptions count]; i += 3) {
            NSString *partnerName = [[granularOptions objectAtIndex:i] description];
            NSString *key = [[granularOptions objectAtIndex:(i + 1)] description];
            NSString *value = [[granularOptions objectAtIndex:(i + 2)] description];
            [alltrackThirdPartySharing addGranularOption:partnerName key:key value:value];
        }
        for (int i = 0; i < [partnerSharingSettings count]; i += 3) {
            NSString *partnerName = [[partnerSharingSettings objectAtIndex:i] description];
            NSString *key = [[partnerSharingSettings objectAtIndex:(i + 1)] description];
            BOOL value = [[partnerSharingSettings objectAtIndex:(i + 2)] boolValue];
            [alltrackThirdPartySharing addPartnerSharingSetting:partnerName key:key value:value];
        }

        [Alltrack trackThirdPartySharing:alltrackThirdPartySharing];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_trackMeasurementConsent" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSNumber class]]) {
            return;
        }
        [Alltrack trackMeasurementConsent:[(NSNumber *)data boolValue]];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_checkForNewAttStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Alltrack checkForNewAttStatus];
    }];

    [self.bridgeRegister registerHandler:@"alltrack_lastDeeplink" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        NSURL *lastDeeplink = [Alltrack lastDeeplink];
        responseCallback(lastDeeplink != nil ? [lastDeeplink absoluteString] : nil);
    }];

    [self.bridgeRegister registerHandler:@"alltrack_setTestOptions" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *baseUrl = [data objectForKey:@"baseUrl"];
        NSString *gdprUrl = [data objectForKey:@"gdprUrl"];
        NSString *extraPath = [data objectForKey:@"extraPath"];
        NSNumber *timerIntervalInMilliseconds = [data objectForKey:@"timerIntervalInMilliseconds"];
        NSNumber *timerStartInMilliseconds = [data objectForKey:@"timerStartInMilliseconds"];
        NSNumber *sessionIntervalInMilliseconds = [data objectForKey:@"sessionIntervalInMilliseconds"];
        NSNumber *subsessionIntervalInMilliseconds = [data objectForKey:@"subsessionIntervalInMilliseconds"];
        NSNumber *teardown = [data objectForKey:@"teardown"];
        NSNumber *deleteState = [data objectForKey:@"deleteState"];
        NSNumber *noBackoffWait = [data objectForKey:@"noBackoffWait"];
        NSNumber *adServicesFrameworkEnabled = [data objectForKey:@"adServicesFrameworkEnabled"];

        AlltrackTestOptions *testOptions = [[AlltrackTestOptions alloc] init];

        if ([self isFieldValid:baseUrl]) {
            testOptions.baseUrl = baseUrl;
        }
        if ([self isFieldValid:gdprUrl]) {
            testOptions.gdprUrl = gdprUrl;
        }
        if ([self isFieldValid:extraPath]) {
            testOptions.extraPath = extraPath;
        }
        if ([self isFieldValid:timerIntervalInMilliseconds]) {
            testOptions.timerIntervalInMilliseconds = timerIntervalInMilliseconds;
        }
        if ([self isFieldValid:timerStartInMilliseconds]) {
            testOptions.timerStartInMilliseconds = timerStartInMilliseconds;
        }
        if ([self isFieldValid:sessionIntervalInMilliseconds]) {
            testOptions.sessionIntervalInMilliseconds = sessionIntervalInMilliseconds;
        }
        if ([self isFieldValid:subsessionIntervalInMilliseconds]) {
            testOptions.subsessionIntervalInMilliseconds = subsessionIntervalInMilliseconds;
        }
        if ([self isFieldValid:teardown]) {
            testOptions.teardown = [teardown boolValue];
            if (testOptions.teardown) {
                [self resetAlltrackBridge];
            }
        }
        if ([self isFieldValid:deleteState]) {
            testOptions.deleteState = [deleteState boolValue];
        }
        if ([self isFieldValid:noBackoffWait]) {
            testOptions.noBackoffWait = [noBackoffWait boolValue];
        }
        if ([self isFieldValid:adServicesFrameworkEnabled]) {
            testOptions.adServicesFrameworkEnabled = [adServicesFrameworkEnabled boolValue];
        }

        [Alltrack setTestOptions:testOptions];
    }];

}

- (void)registerAugmentedView {
    [self.bridgeRegister registerHandler:@"alltrack_fbPixelEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *pixelID = [data objectForKey:@"pixelID"];
        if (pixelID == nil) {
            [[ALTAlltrackFactory logger] error:@"Can't bridge an event without a referral Pixel ID. Check your webview Pixel configuration"];
            return;
        }
        NSString *evtName = [data objectForKey:@"evtName"];
        NSString *eventToken = [self getEventTokenFromFbPixelEventName:evtName];
        if (eventToken == nil) {
            [[ALTAlltrackFactory logger] debug:@"No mapping found for the fb pixel event %@, trying to fall back to the default event token", evtName];
            eventToken = self.fbPixelDefaultEventToken;
        }
        if (eventToken == nil) {
            [[ALTAlltrackFactory logger] debug:@"There is not a default event token configured or a mapping found for event named: '%@'. It won't be tracked as an alltrack event", evtName];
            return;
        }

        ALTEvent *fbPixelEvent = [ALTEvent eventWithEventToken:eventToken];
        if (![fbPixelEvent isValid]) {
            return;
        }

        id customData = [data objectForKey:@"customData"];
        [fbPixelEvent addPartnerParameter:@"_fb_pixel_referral_id" value:pixelID];
        // [fbPixelEvent addPartnerParameter:@"_eventName" value:evtName];
        if ([customData isKindOfClass:[NSString class]]) {
            NSError *jsonParseError = nil;
            NSDictionary *params = [NSJSONSerialization JSONObjectWithData:[customData dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&jsonParseError];
            [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *keyS = [key description];
                NSString *valueS = [obj description];
                [fbPixelEvent addPartnerParameter:keyS value:valueS];
            }];
        }
        [Alltrack trackEvent:fbPixelEvent];
    }];
}

#pragma mark - Private & helper methods

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return NO;
    }
    if ([field isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[field description] length] == 0) {
        return NO;
    }
    return !!field;
}

- (NSString *)getFbAppId {
    NSString *facebookLoggingOverrideAppID = [self getValueFromBundleByKey:@"FacebookLoggingOverrideAppID"];
    if (facebookLoggingOverrideAppID != nil) {
        return facebookLoggingOverrideAppID;
    }

    return [self getValueFromBundleByKey:@"FacebookAppID"];
}

- (NSString *)getValueFromBundleByKey:(NSString *)key {
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:key] copy];
}

- (NSString *)getEventTokenFromFbPixelEventName:(NSString *)fbPixelEventName {
    if (self.fbPixelMapping == nil) {
        return nil;
    }

    return [self.fbPixelMapping objectForKey:fbPixelEventName];
}

- (NSString *)convertJsonDictionaryToNSString:(NSDictionary *)jsonDictionary {
    if (jsonDictionary == nil) {
        return nil;
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Unable to conver NSDictionary with JSON response to JSON string: %@", error);
        return nil;
    }

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSNumber *)fieldToNSNumber:(NSObject *)field {
    if (![self isFieldValid:field]) {
        return nil;
    }
    NSNumberFormatter *formatString = [[NSNumberFormatter alloc] init];
    return [formatString numberFromString:[field description]];
}

@end
