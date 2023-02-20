//
//  ALTSuccessResponseData.h
//  alltrack
//
//  Created by Pedro Filipe on 05/01/16.
//  Copyright © 2016 alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTSessionSuccess : NSObject <NSCopying>

/**
 * @brief Message from the alltrack backend.
 */
@property (nonatomic, copy, nullable) NSString *message;

/**
 * @brief Timestamp from the alltrack backend.
 */
@property (nonatomic, copy, nullable) NSString *timeStamp;

/**
 * @brief Alltrack identifier of the device.
 */
@property (nonatomic, copy, nullable) NSString *adid;

/**
 * @brief Backend response in JSON format.
 */
@property (nonatomic, strong, nullable) NSDictionary *jsonResponse;

/**
 * @brief Initialisation method.
 *
 * @return ALTSessionSuccess instance.
 */
+ (nullable ALTSessionSuccess *)sessionSuccessResponseData;

@end
