//
//  ALTTimerOnce.h
//  alltrack
//
//  Created by Pedro Filipe on 03/06/15.
//  Copyright (c) 2015 alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ALTTimerOnce : NSObject

+ (ALTTimerOnce *)timerWithBlock:(dispatch_block_t)block
                           queue:(dispatch_queue_t)queue
                            name:(NSString*)name;

- (id)initBlock:(dispatch_block_t)block
          queue:(dispatch_queue_t)queue
           name:(NSString*)name;

- (void)startIn:(NSTimeInterval)startIn;
- (NSTimeInterval)fireIn;
- (void)cancel;
@end
