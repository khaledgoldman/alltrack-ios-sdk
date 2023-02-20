#import <Foundation/Foundation.h>

#import "ALTEvent.h"

@interface ALTCriteoProduct : NSObject

@property (nonatomic, assign) float criteoPrice;

@property (nonatomic, assign) NSUInteger criteoQuantity;

@property (nonatomic, copy, nullable) NSString *criteoProductID;

- (nullable id)initWithId:(nullable NSString *)productId price:(float)price quantity:(NSUInteger)quantity;

+ (nullable ALTCriteoProduct *)productWithId:(nullable NSString *)productId price:(float)price quantity:(NSUInteger)quantity;

@end

@interface ALTCriteo : NSObject

+ (void)injectPartnerIdIntoCriteoEvents:(nullable NSString *)partnerId;

+ (void)injectCustomerIdIntoCriteoEvents:(nullable NSString *)customerId;

+ (void)injectHashedEmailIntoCriteoEvents:(nullable NSString *)hashEmail;

+ (void)injectUserSegmentIntoCriteoEvents:(nullable NSString *)userSegment;

+ (void)injectDeeplinkIntoEvent:(nullable ALTEvent *)event url:(nullable NSURL *)url;

+ (void)injectCartIntoEvent:(nullable ALTEvent *)event products:(nullable NSArray *)products;

+ (void)injectUserLevelIntoEvent:(nullable ALTEvent *)event uiLevel:(NSUInteger)uiLevel;

+ (void)injectCustomEventIntoEvent:(nullable ALTEvent *)event uiData:(nullable NSString *)uiData;

+ (void)injectUserStatusIntoEvent:(nullable ALTEvent *)event uiStatus:(nullable NSString *)uiStatus;

+ (void)injectViewProductIntoEvent:(nullable ALTEvent *)event productId:(nullable NSString *)productId;

+ (void)injectViewListingIntoEvent:(nullable ALTEvent *)event productIds:(nullable NSArray *)productIds;

+ (void)injectAchievementUnlockedIntoEvent:(nullable ALTEvent *)event uiAchievement:(nullable NSString *)uiAchievement;

+ (void)injectViewSearchDatesIntoCriteoEvents:(nullable NSString *)checkInDate checkOutDate:(nullable NSString *)checkOutDate;

+ (void)injectCustomEvent2IntoEvent:(nullable ALTEvent *)event uiData2:(nullable NSString *)uiData2 uiData3:(NSUInteger)uiData3;

+ (void)injectTransactionConfirmedIntoEvent:(nullable ALTEvent *)event
                                   products:(nullable NSArray *)products
                              transactionId:(nullable NSString *)transactionId
                                newCustomer:(nullable NSString *)newCustomer;

@end
