//
//  ALTSessionParameters.m
//  Alltrack
//
//  Created by Pedro Filipe on 27/05/16.
//  Copyright © 2016 alltrack GmbH. All rights reserved.
//

#import "ALTSessionParameters.h"

@implementation ALTSessionParameters

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];

    if (self == nil) {
        return nil;
    }

    return self;
}

#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    ALTSessionParameters* copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy.callbackParameters = [self.callbackParameters copyWithZone:zone];
        copy.partnerParameters  = [self.partnerParameters copyWithZone:zone];
    }

    return copy;
}

@end
