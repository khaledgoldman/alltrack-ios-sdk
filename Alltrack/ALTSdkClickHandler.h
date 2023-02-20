//
//  ALTSdkClickHandler.h
//  Alltrack SDK
//
//  Created by Pedro Filipe (@nonelse) on 21st April 2016.
//  Copyright © 2016 Alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALTActivityPackage.h"
#import "ALTActivityHandler.h"
#import "ALTRequestHandler.h"
#import "ALTUrlStrategy.h"

@interface ALTSdkClickHandler : NSObject <ALTResponseCallback>

- (id)initWithActivityHandler:(id<ALTActivityHandler>)activityHandler
                startsSending:(BOOL)startsSending
                    userAgent:(NSString *)userAgent
                  urlStrategy:(ALTUrlStrategy *)urlStrategy;
- (void)pauseSending;
- (void)resumeSending;
- (void)sendSdkClick:(ALTActivityPackage *)sdkClickPackage;
- (void)teardown;

@end
