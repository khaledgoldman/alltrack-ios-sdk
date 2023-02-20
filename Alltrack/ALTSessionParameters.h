//
//  ALTSessionParameters.h
//  Alltrack
//
//  Created by Pedro Filipe on 27/05/16.
//  Copyright © 2016 alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTSessionParameters : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableDictionary* callbackParameters;
@property (nonatomic, strong) NSMutableDictionary* partnerParameters;

@end
