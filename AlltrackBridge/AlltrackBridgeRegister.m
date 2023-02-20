//
//  AlltrackBridgeRegister.m
//  Alltrack SDK
//
//  Created by Pedro Filipe (@nonelse) on 10th June 2016.
//  Copyright © 2016-2018 Alltrack GmbH. All rights reserved.
//

#import "AlltrackBridgeRegister.h"

static NSString * const kHandlerPrefix = @"alltrack_";
static NSString * fbAppIdStatic = nil;

@interface AlltrackBridgeRegister()

@property (nonatomic, strong) WKWebViewJavascriptBridge *wkwvjb;

@end

@implementation AlltrackBridgeRegister

- (id)initWithWKWebView:(WKWebView*)webView {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.wkwvjb = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    return self;
}

- (void)setWKWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate {
    [self.wkwvjb setWebViewDelegate:webViewDelegate];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self.wkwvjb callHandler:handlerName data:data];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
    [self.wkwvjb registerHandler:handlerName handler:handler];
}

- (void)augmentHybridWebView:(NSString *)fbAppId {
    fbAppIdStatic = fbAppId;
}

+ (NSString *)AlltrackBridge_js {
    if (fbAppIdStatic != nil) {
        return [NSString stringWithFormat:@"%@%@",
                [AlltrackBridgeRegister alltrack_js],
                [AlltrackBridgeRegister augmented_js]];
    } else {
        return [AlltrackBridgeRegister alltrack_js];
    }
}

#define __alt_js_func__(x) #x
// BEGIN preprocessorJSCode

+ (NSString *)augmented_js {
    return [NSString stringWithFormat:
        @__alt_js_func__(;(function() {
            window['fbmq_%@'] = {
                'getProtocol' : function() {
                    return 'fbmq-0.1';
                },
                'sendEvent': function(pixelID, evtName, customData) {
                    Alltrack.fbPixelEvent(pixelID, evtName, customData);
                }
            };
        })();) // END preprocessorJSCode
     , fbAppIdStatic];
}

+ (NSString *)alltrack_js {
    static NSString *preprocessorJSCode = @__alt_js_func__(;(function() {
        if (window.Alltrack) {
            return;
        }

        // Copied from alltrack.js
        window.Alltrack = {
            appDidLaunch: function(alltrackConfig) {
                if (WebViewJavascriptBridge) {
                    if (alltrackConfig) {
                        if (!alltrackConfig.getSdkPrefix()) {
                            alltrackConfig.setSdkPrefix(this.getSdkPrefix());
                        }
                        this.sdkPrefix = alltrackConfig.getSdkPrefix();
                        alltrackConfig.registerCallbackHandlers();
                        WebViewJavascriptBridge.callHandler('alltrack_appDidLaunch', alltrackConfig, null);
                    }
                }
            },
            trackEvent: function(alltrackEvent) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_trackEvent', alltrackEvent, null);
                }
            },
            trackAdRevenue: function(source, payload) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_trackAdRevenue', {source: source, payload: payload}, null);
                }
            },
            trackSubsessionStart: function() {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_trackSubsessionStart', null, null);
                }
            },
            trackSubsessionEnd: function() {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_trackSubsessionEnd', null, null);
                }
            },
            setEnabled: function(enabled) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_setEnabled', enabled, null);
                }
            },
            isEnabled: function(callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_isEnabled', null,
                                                        function(response) {
                                                            callback(new Boolean(response));
                                                        });
                }
            },
            appWillOpenUrl: function(url) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_appWillOpenUrl', url, null);
                }
            },
            setDeviceToken: function(deviceToken) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_setDeviceToken', deviceToken, null);
                }
            },
            setOfflineMode: function(isOffline) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_setOfflineMode', isOffline, null);
                }
            },
            getIdfa: function(callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_idfa', null, callback);
                }
                },
            requestTrackingAuthorizationWithCompletionHandler: function(callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_requestTrackingAuthorizationWithCompletionHandler', null, callback);
                }
            },
            getAppTrackingAuthorizationStatus: function(callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_appTrackingAuthorizationStatus', null, callback);
                }
            },
            updateConversionValue: function(conversionValue) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_updateConversionValue', conversionValue, null);
                }
            },
            updateConversionValueWithCallback: function(conversionValue, callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_updateConversionValueCompletionHandler', conversionValue, callback);
                }
            },
            updateConversionValueWithCoarseValueAndCallback: function(conversionValue, coarseValue, callback) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_updateConversionValueCoarseValueCompletionHandler',
                                                        {conversionValue: conversionValue, coarseValue: coarseValue},
                                                        callback);
                }
            },
            updateConversionValueWithCoarseValueLockWindowAndCallback: function(conversionValue, coarseValue, lockWindow, callback) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_updateConversionValueCoarseValueLockWindowCompletionHandler',
                                                        {conversionValue: conversionValue, coarseValue: coarseValue},
                                                        callback);
                }
            },
            getAdid: function(callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_adid', null, callback);
                }
            },
            getAttribution: function(callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_attribution', null, callback);
                }
            },
            sendFirstPackages: function() {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_sendFirstPackages', null, null);
                }
            },
            addSessionCallbackParameter: function(key, value) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_addSessionCallbackParameter', {key: key, value: value}, null);
                }
            },
            addSessionPartnerParameter: function(key, value) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_addSessionPartnerParameter', {key: key, value: value}, null);
                }
            },
            removeSessionCallbackParameter: function(key) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_removeSessionCallbackParameter', key, null);
                }
            },
            removeSessionPartnerParameter: function(key) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_removeSessionPartnerParameter', key, null);
                }
            },
            resetSessionCallbackParameters: function() {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_resetSessionCallbackParameters', null, null);
                }
            },
            resetSessionPartnerParameters: function() {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_resetSessionPartnerParameters', null, null);
                }
            },
            gdprForgetMe: function() {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_gdprForgetMe', null, null);
                }
            },
            disableThirdPartySharing: function() {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_disableThirdPartySharing', null, null);
                }
            },
            trackThirdPartySharing: function(alltrackThirdPartySharing) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_trackThirdPartySharing', alltrackThirdPartySharing, null);
                }
            },
            trackMeasurementConsent: function(consentMeasurement) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_trackMeasurementConsent', consentMeasurement, null);
                }
            },
            checkForNewAttStatus: function() {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_checkForNewAttStatus', null, null);
                }
            },
            getLastDeeplink: function(callback) {
                if (WebViewJavascriptBridge) {
                    WebViewJavascriptBridge.callHandler('alltrack_lastDeeplink', null, callback);
                }
            },
            fbPixelEvent: function(pixelID, evtName, customData) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_fbPixelEvent',
                                                        {
                                                            pixelID: pixelID,
                                                            evtName:evtName,
                                                            customData: customData
                                                        },
                                                        null);
                }
            },
            getSdkVersion: function(callback) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_sdkVersion', this.getSdkPrefix(), callback);
                }
            },
            getSdkPrefix: function() {
                if (this.sdkPrefix) {
                    return this.sdkPrefix;
                } else {
                    return 'web-bridge4.33.4';
                }
            },
            setTestOptions: function(testOptions) {
                if (WebViewJavascriptBridge != null) {
                    WebViewJavascriptBridge.callHandler('alltrack_setTestOptions', testOptions, null);
                }
            }
        };

        // Copied from alltrack_event.js
        window.AlltrackEvent = function(eventToken) {
            this.eventToken = eventToken;
            this.revenue = null;
            this.currency = null;
            this.transactionId = null;
            this.callbackId = null;
            this.callbackParameters = [];
            this.partnerParameters = [];
        };

        AlltrackEvent.prototype.addCallbackParameter = function(key, value) {
            this.callbackParameters.push(key);
            this.callbackParameters.push(value);
        };
        AlltrackEvent.prototype.addPartnerParameter = function(key, value) {
            this.partnerParameters.push(key);
            this.partnerParameters.push(value);
        };
        AlltrackEvent.prototype.setRevenue = function(revenue, currency) {
            this.revenue = revenue;
            this.currency = currency;
        };
        AlltrackEvent.prototype.setTransactionId = function(transactionId) {
            this.transactionId = transactionId;
        };
        AlltrackEvent.prototype.setCallbackId = function(callbackId) {
            this.callbackId = callbackId;
        };

        // Alltrack Third Party Sharing
        window.AlltrackThirdPartySharing = function(isEnabled) {
            this.isEnabled = isEnabled;
            this.granularOptions = [];
            this.partnerSharingSettings = [];
        };
        AlltrackThirdPartySharing.prototype.addGranularOption = function(partnerName, key, value) {
            this.granularOptions.push(partnerName);
            this.granularOptions.push(key);
            this.granularOptions.push(value);
        };
        AlltrackThirdPartySharing.prototype.addPartnerSharingSetting = function(partnerName, key, value) {
            this.partnerSharingSettings.push(partnerName);
            this.partnerSharingSettings.push(key);
            this.partnerSharingSettings.push(value);
        };

        // Copied from alltrack_config.js
        window.AlltrackConfig = function(appToken, environment, legacy) {
            if (arguments.length === 2) {
                // New format does not require bridge as first parameter.
                this.appToken = appToken;
                this.environment = environment;
            } else if (arguments.length === 3) {
                // New format with allowSuppressLogLevel.
                if (typeof(legacy) == typeof(true)) {
                    this.appToken = appToken;
                    this.environment = environment;
                    this.allowSuppressLogLevel = legacy;
                } else {
                    // Old format with first argument being the bridge instance.
                    this.bridge = appToken;
                    this.appToken = environment;
                    this.environment = legacy;
                }
            }

            this.sdkPrefix = null;
            this.defaultTracker = null;
            this.externalDeviceId = null;
            this.logLevel = null;
            this.eventBufferingEnabled = null;
            this.coppaCompliantEnabled = null;
            this.linkMeEnabled = null;
            this.sendInBackground = null;
            this.delayStart = null;
            this.userAgent = null;
            this.isDeviceKnown = null;
            this.needsCost = null;
            this.allowAdServicesInfoReading = null;
            this.allowIdfaReading = null;
            this.allowSkAdNetworkHandling = null;
            this.secretId = null;
            this.info1 = null;
            this.info2 = null;
            this.info3 = null;
            this.info4 = null;
            this.openDeferredDeeplink = null;
            this.fbPixelDefaultEventToken = null;
            this.fbPixelMapping = [];
            this.attributionCallback = null;
            this.eventSuccessCallback = null;
            this.eventFailureCallback = null;
            this.sessionSuccessCallback = null;
            this.sessionFailureCallback = null;
            this.deferredDeeplinkCallback = null;
            this.urlStrategy = null;
        };

        AlltrackConfig.EnvironmentSandbox = 'sandbox';
        AlltrackConfig.EnvironmentProduction = 'production';

        AlltrackConfig.LogLevelVerbose = 'VERBOSE';
        AlltrackConfig.LogLevelDebug = 'DEBUG';
        AlltrackConfig.LogLevelInfo = 'INFO';
        AlltrackConfig.LogLevelWarn = 'WARN';
        AlltrackConfig.LogLevelError = 'ERROR';
        AlltrackConfig.LogLevelAssert = 'ASSERT';
        AlltrackConfig.LogLevelSuppress = 'SUPPRESS';

        AlltrackConfig.UrlStrategyIndia = 'UrlStrategyIndia';
        AlltrackConfig.UrlStrategyChina = 'UrlStrategyChina';
        AlltrackConfig.UrlStrategyCn = 'UrlStrategyCn';
        AlltrackConfig.DataResidencyEU = 'DataResidencyEU';
        AlltrackConfig.DataResidencyTR = 'DataResidencyTR';
        AlltrackConfig.DataResidencyUS = 'DataResidencyUS';

        AlltrackConfig.prototype.registerCallbackHandlers = function() {
            var registerCallbackHandler = function(callbackName) {
                var callback = this[callbackName];
                if (!callback) {
                    return;
                }
                var regiteredCallbackName = 'alltrackJS_' + callbackName;
                WebViewJavascriptBridge.registerHandler(regiteredCallbackName, callback);
                this[callbackName] = regiteredCallbackName;
            };
            registerCallbackHandler.call(this, 'attributionCallback');
            registerCallbackHandler.call(this, 'eventSuccessCallback');
            registerCallbackHandler.call(this, 'eventFailureCallback');
            registerCallbackHandler.call(this, 'sessionSuccessCallback');
            registerCallbackHandler.call(this, 'sessionFailureCallback');
            registerCallbackHandler.call(this, 'deferredDeeplinkCallback');
        };
        AlltrackConfig.prototype.getSdkPrefix = function() {
            return this.sdkPrefix;
        };
        AlltrackConfig.prototype.setSdkPrefix = function(sdkPrefix) {
            this.sdkPrefix = sdkPrefix;
        };
        AlltrackConfig.prototype.setDefaultTracker = function(defaultTracker) {
            this.defaultTracker = defaultTracker;
        };
        AlltrackConfig.prototype.setExternalDeviceId = function(externalDeviceId) {
            this.externalDeviceId = externalDeviceId;
        };
        AlltrackConfig.prototype.setLogLevel = function(logLevel) {
            this.logLevel = logLevel;
        };
        AlltrackConfig.prototype.setEventBufferingEnabled = function(isEnabled) {
            this.eventBufferingEnabled = isEnabled;
        };
        AlltrackConfig.prototype.setCoppaCompliantEnabled = function(isEnabled) {
            this.coppaCompliantEnabled = isEnabled;
        };
        AlltrackConfig.prototype.setLinkMeEnabled = function(isEnabled) {
            this.linkMeEnabled = isEnabled;
        };
        AlltrackConfig.prototype.setSendInBackground = function(isEnabled) {
            this.sendInBackground = isEnabled;
        };
        AlltrackConfig.prototype.setDelayStart = function(delayStartInSeconds) {
            this.delayStart = delayStartInSeconds;
        };
        AlltrackConfig.prototype.setUserAgent = function(userAgent) {
            this.userAgent = userAgent;
        };
        AlltrackConfig.prototype.setIsDeviceKnown = function(isDeviceKnown) {
            this.isDeviceKnown = isDeviceKnown;
        };
        AlltrackConfig.prototype.setNeedsCost = function(needsCost) {
            this.needsCost = needsCost;
        };
        AlltrackConfig.prototype.setAllowiAdInfoReading = function(allowiAdInfoReading) {
            // Apple has official sunset support for Apple Search Ads attribution via iAd.framework as of February 7th 2023
        };
        AlltrackConfig.prototype.setAllowAdServicesInfoReading = function(allowAdServicesInfoReading) {
            this.allowAdServicesInfoReading = allowAdServicesInfoReading;
        };
        AlltrackConfig.prototype.setAllowIdfaReading = function(allowIdfaReading) {
            this.allowIdfaReading = allowIdfaReading;
        };
        AlltrackConfig.prototype.deactivateSkAdNetworkHandling = function() {
            this.allowSkAdNetworkHandling = false;
        };
        AlltrackConfig.prototype.setAppSecret = function(secretId, info1, info2, info3, info4) {
            this.secretId = secretId;
            this.info1 = info1;
            this.info2 = info2;
            this.info3 = info3;
            this.info4 = info4;
        };
        AlltrackConfig.prototype.setOpenDeferredDeeplink = function(shouldOpen) {
            this.openDeferredDeeplink = shouldOpen;
        };
        AlltrackConfig.prototype.setAttributionCallback = function(callback) {
            this.attributionCallback = callback;
        };
        AlltrackConfig.prototype.setEventSuccessCallback = function(callback) {
            this.eventSuccessCallback = callback;
        };
        AlltrackConfig.prototype.setEventFailureCallback = function(callback) {
            this.eventFailureCallback = callback;
        };
        AlltrackConfig.prototype.setSessionSuccessCallback = function(callback) {
            this.sessionSuccessCallback = callback;
        };
        AlltrackConfig.prototype.setSessionFailureCallback = function(callback) {
            this.sessionFailureCallback = callback;
        };
        AlltrackConfig.prototype.setDeferredDeeplinkCallback = function(callback) {
            this.deferredDeeplinkCallback = callback;
        };
        AlltrackConfig.prototype.setFbPixelDefaultEventToken = function(fbPixelDefaultEventToken) {
            this.fbPixelDefaultEventToken = fbPixelDefaultEventToken;
        };
        AlltrackConfig.prototype.addFbPixelMapping = function(fbEventNameKey, altEventTokenValue) {
            this.fbPixelMapping.push(fbEventNameKey);
            this.fbPixelMapping.push(altEventTokenValue);
        };
        AlltrackConfig.prototype.setUrlStrategy = function(urlStrategy) {
            this.urlStrategy = urlStrategy;
        };

    })();); // END preprocessorJSCode
    //, augmentedSection];
#undef __alt_js_func__
    return preprocessorJSCode;
}

@end
