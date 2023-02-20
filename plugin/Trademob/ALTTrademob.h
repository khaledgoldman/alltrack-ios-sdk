
#import <Foundation/Foundation.h>

#import "ALTEvent.h"

@interface ALTTrademobItem : NSObject

@property (nonatomic, assign) float price;

@property (nonatomic, assign) NSUInteger quantity;

@property (nonatomic, copy, nullable) NSString *itemId;

- (nullable instancetype)initWithId:(nullable NSString *)itemId price:(float)price quantity:(NSUInteger)quantity;

@end

@interface ALTTrademob : NSObject

+ (void)injectViewListingIntoEvent:(nullable ALTEvent *)event
                           itemIds:(nullable NSArray *)itemIds
                          metadata:(nullable NSDictionary *)metadata;

+ (void)injectViewItemIntoEvent:(nullable ALTEvent *)event
                         itemId:(nullable NSString *)itemId
                       metadata:(nullable NSDictionary *)metadata;


+ (void)injectAddToBasketIntoEvent:(nullable ALTEvent *)event
                             items:(nullable NSArray *)items
                          metadata:(nullable NSDictionary *)metadata;

+ (void)injectCheckoutIntoEvent:(nullable ALTEvent *)event
                          items:(nullable NSArray *)items
                       metadata:(nullable NSDictionary *)metadata;

@end
