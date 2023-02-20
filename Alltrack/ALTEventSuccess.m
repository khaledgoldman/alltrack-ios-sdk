//
//  ALTEventSuccess.m
//  alltrack
//
//  Created by Pedro Filipe on 17/02/16.
//  Copyright © 2016 alltrack GmbH. All rights reserved.
//

#import "ALTEventSuccess.h"

@implementation ALTEventSuccess

#pragma mark - Object lifecycle methods

- (id)init {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }

    return self;
}

+ (ALTEventSuccess *)eventSuccessResponseData {
    return [[ALTEventSuccess alloc] init];
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone {
    ALTEventSuccess *copy = [[[self class] allocWithZone:zone] init];

    if (copy) {
        copy.message = [self.message copyWithZone:zone];
        copy.timeStamp = [self.timeStamp copyWithZone:zone];
        copy.adid = [self.adid copyWithZone:zone];
        copy.eventToken = [self.eventToken copyWithZone:zone];
        copy.callbackId = [self.callbackId copyWithZone:zone];
        copy.jsonResponse = [self.jsonResponse copyWithZone:zone];
    }

    return copy;
}

#pragma mark - NSObject protocol methods

- (NSString *)description {
    return [NSString stringWithFormat: @"Event Success msg:%@ time:%@ adid:%@ event:%@ cid:%@ json:%@",
            self.message,
            self.timeStamp,
            self.adid,
            self.eventToken,
            self.callbackId,
            self.jsonResponse];
}

@end
