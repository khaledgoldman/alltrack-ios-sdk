//
//  AlltrackTrackingHelper.h
//  AlltrackExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlltrackDelegate;

@interface AlltrackTrackingHelper : NSObject

+ (id)sharedInstance;

- (void)initialize:(NSObject<AlltrackDelegate> *)delegate;
- (void)trackSimpleEvent;
- (void)trackRevenueEvent;
- (void)trackCallbackEvent;
- (void)trackPartnerEvent;

@end
