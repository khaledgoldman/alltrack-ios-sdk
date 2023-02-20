//
//  AppDelegate.m
//  AlltrackExample-ObjC
//
//  Created by Pedro Filipe (@nonelse) on 12th October 2015.
//  Copyright © 2015-Present Alltrack GmbH. All rights reserved.
//

#import "Constants.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure Alltrack SDK.
    NSString *appToken = kAppToken;
    NSString *environment = ALTEnvironmentSandbox;
    ALTConfig *alltrackConfig = [ALTConfig configWithAppToken:appToken environment:environment];
    
    // Change the log level.
    [alltrackConfig setLogLevel:ALTLogLevelVerbose];
    
    // Enable event buffering.
    // [alltrackConfig setEventBufferingEnabled:YES];
    
    // Set default tracker.
    // [alltrackConfig setDefaultTracker:@"{TrackerToken}"];
    
    // Send in the background.
    // [alltrackConfig setSendInBackground:YES];
    
    // Enable COPPA compliance.
    // [alltrackConfig setCoppaCompliantEnabled:YES];
    
    // Enable LinkMe feature.
    // [alltrackConfig setLinkMeEnabled:YES];
    
    // Set an attribution delegate.
    [alltrackConfig setDelegate:self];
    
    // Delay the first session of the SDK.
    // [alltrackConfig setDelayStart:7];
    
    // Add session callback parameters.
    [Alltrack addSessionCallbackParameter:@"sp_foo" value:@"sp_bar"];
    [Alltrack addSessionCallbackParameter:@"sp_key" value:@"sp_value"];
    
    // Add session partner parameters.
    [Alltrack addSessionPartnerParameter:@"sp_foo" value:@"sp_bar"];
    [Alltrack addSessionPartnerParameter:@"sp_key" value:@"sp_value"];
    
    // Remove session callback parameter.
    [Alltrack removeSessionCallbackParameter:@"sp_key"];
    
    // Remove session partner parameter.
    [Alltrack removeSessionPartnerParameter:@"sp_foo"];
    
    // Remove all session callback parameters.
    // [Alltrack resetSessionCallbackParameters];
    
    // Remove all session partner parameters.
    // [Alltrack resetSessionPartnerParameters];
    
    // Initialise the SDK.
    [Alltrack appDidLaunch:alltrackConfig];
    
    // Put the SDK in offline mode.
    // [Alltrack setOfflineMode:YES];
    
    // Disable the SDK.
    // [Alltrack setEnabled:NO];
    
    // Interrupt delayed start set with setDelayStart: method.
    // [Alltrack sendFirstPackages];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"Scheme based deep link opened an app: %@", url);
    // Pass deep link to Alltrack in order to potentially reattribute user.
    [Alltrack appWillOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    if ([[userActivity activityType] isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSLog(@"Universal link opened an app: %@", [userActivity webpageURL]);
        // Pass deep link to Alltrack in order to potentially reattribute user.
        [Alltrack appWillOpenUrl:[userActivity webpageURL]];
    }
    return YES;
}

- (void)alltrackAttributionChanged:(ALTAttribution *)attribution {
    NSLog(@"Attribution callback called!");
    NSLog(@"Attribution: %@", attribution);
}

- (void)alltrackEventTrackingSucceeded:(ALTEventSuccess *)eventSuccessResponseData {
    NSLog(@"Event success callback called!");
    NSLog(@"Event success data: %@", eventSuccessResponseData);
}

- (void)alltrackEventTrackingFailed:(ALTEventFailure *)eventFailureResponseData {
    NSLog(@"Event failure callback called!");
    NSLog(@"Event failure data: %@", eventFailureResponseData);
}

- (void)alltrackSessionTrackingSucceeded:(ALTSessionSuccess *)sessionSuccessResponseData {
    NSLog(@"Session success callback called!");
    NSLog(@"Session success data: %@", sessionSuccessResponseData);
}

- (void)alltrackSessionTrackingFailed:(ALTSessionFailure *)sessionFailureResponseData {
    NSLog(@"Session failure callback called!");
    NSLog(@"Session failure data: %@", sessionFailureResponseData);
}

- (BOOL)alltrackDeeplinkResponse:(NSURL *)deeplink {
    NSLog(@"Deferred deep link callback called!");
    NSLog(@"Deferred deep link URL: %@", [deeplink absoluteString]);
    
    // Allow Alltrack SDK to open received deferred deep link.
    // If you don't want it to open it, return NO; instead.
    return YES;
}

- (void)alltrackConversionValueUpdated:(NSNumber *)conversionValue {
    NSLog(@"Conversion value updated callback called!");
    NSLog(@"Conversion value: %@", conversionValue);
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Show ATT dialog.
    if (@available(iOS 14, *)) {
        [Alltrack requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
            // Process user's response.
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
