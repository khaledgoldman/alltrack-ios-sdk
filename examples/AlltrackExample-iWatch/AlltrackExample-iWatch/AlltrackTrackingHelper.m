//
//  AlltrackTrackingHelper.m
//  AlltrackExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Alltrack GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Alltrack.h"
#import "AlltrackTrackingHelper.h"

@implementation AlltrackTrackingHelper

+ (id)sharedInstance {
    static AlltrackTrackingHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    
    return sharedHelper;
}

- (void)initialize:(NSObject<AlltrackDelegate> *)delegate {
    NSString *yourAppToken = @"{YourAppToken}";
    NSString *environment = ALTEnvironmentSandbox;
    ALTConfig *alltrackConfig = [ALTConfig configWithAppToken:yourAppToken environment:environment];
    
    // Change the log level.
    [alltrackConfig setLogLevel:ALTLogLevelVerbose];
    
    // Enable event buffering.
    // [alltrackConfig setEventBufferingEnabled:YES];
    
    // Set default tracker.
    // [alltrackConfig setDefaultTracker:@"{TrackerToken}"];
    
    // Set an attribution delegate.
    [alltrackConfig setDelegate:delegate];
    
    [Alltrack appDidLaunch:alltrackConfig];
    
    // Put the SDK in offline mode.
    // [Alltrack setOfflineMode:YES];
    
    // Disable the SDK.
    // [Alltrack setEnabled:NO];
}

- (void)trackSimpleEvent {
    ALTEvent *event = [ALTEvent eventWithEventToken:@"{YourEventToken}"];
    
    [Alltrack trackEvent:event];
}

- (void)trackRevenueEvent {
    ALTEvent *event = [ALTEvent eventWithEventToken:@"{YourEventToken}"];
    
    // Add revenue 15 cent of an euro.
    [event setRevenue:0.015 currency:@"EUR"];
    
    [Alltrack trackEvent:event];
}

- (void)trackCallbackEvent {
    ALTEvent *event = [ALTEvent eventWithEventToken:@"{YourEventToken}"];
    
    // Add callback parameters to this event.
    [event addCallbackParameter:@"key" value:@"value"];
    
    [Alltrack trackEvent:event];
}

- (void)trackPartnerEvent {
    ALTEvent *event = [ALTEvent eventWithEventToken:@"{YourEventToken}"];
    
    // Add partner parameteres to this event.
    [event addPartnerParameter:@"foo" value:@"bar"];
    
    [Alltrack trackEvent:event];
}

@end
