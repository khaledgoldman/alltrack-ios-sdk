//
//  AlltrackLoggingHelper.h
//  AlltrackExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlltrackLoggingHelper : NSObject

+ (id)sharedInstance;

- (void)logText:(NSString *)text;

@end
