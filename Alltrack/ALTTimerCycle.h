//
//  ALTTimerCycle.h
//  alltrack
//
//  Created by Pedro Filipe on 03/06/15.
//  Copyright (c) 2015 alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTTimerCycle : NSObject

+ (ALTTimerCycle *)timerWithBlock:(dispatch_block_t)block
                            queue:(dispatch_queue_t)queue
                        startTime:(NSTimeInterval)startTime
                     intervalTime:(NSTimeInterval)intervalTime
                             name:(NSString*)name;

- (id)initBlock:(dispatch_block_t)block
          queue:(dispatch_queue_t)queue
      startTime:(NSTimeInterval)startTime
   intervalTime:(NSTimeInterval)intervalTime
           name:(NSString*)name;

- (void)resume;
- (void)suspend;
- (void)cancel;
@end
