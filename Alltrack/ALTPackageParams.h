//
//  ALTPackageParams.h
//  Alltrack SDK
//
//  Created by Pedro Filipe (@nonelse) on 17th November 2014.
//  Copyright (c) 2014-2021 alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTPackageParams : NSObject

@property (nonatomic, copy) NSString *fbAnonymousId;
@property (nonatomic, copy) NSString *idfv;
@property (nonatomic, copy) NSString *clientSdk;
@property (nonatomic, copy) NSString *bundleIdentifier;
@property (nonatomic, copy) NSString *buildNumber;
@property (nonatomic, copy) NSString *versionNumber;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *osName;
@property (nonatomic, copy) NSString *osVersion;
@property (nonatomic, copy) NSString *installedAt;
@property (nonatomic, assign) NSUInteger startedAt;

- (id)initWithSdkPrefix:(NSString *)sdkPrefix;

+ (ALTPackageParams *)packageParamsWithSdkPrefix:(NSString *)sdkPrefix;

@end
