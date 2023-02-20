#import "Alltrack.h"
#import "ALTCriteo.h"
#import "ALTAlltrackFactory.h"

static const NSUInteger MAX_VIEW_LISTING_PRODUCTS = 3;

@implementation ALTCriteoProduct

- (id)initWithId:(NSString *)productId price:(float)price quantity:(NSUInteger)quantity {
    self = [super init];

    if (self == nil) {
        return nil;
    }

    self.criteoPrice = price;
    self.criteoQuantity = quantity;
    self.criteoProductID = productId;

    return self;
}

+ (ALTCriteoProduct *)productWithId:(NSString *)productId price:(float)price quantity:(NSUInteger)quantity {
    return [[ALTCriteoProduct alloc] initWithId:productId price:price quantity:quantity];
}

@end

@implementation ALTCriteo

static NSString * hashEmailInternal;
static NSString * partnerIdInternal;
static NSString * customerIdInternal;
static NSString * userSegmentInternal;
static NSString * checkInDateInternal;
static NSString * checkOutDateInternal;

+ (id<ALTLogger>)logger {
    return ALTAlltrackFactory.logger;
}

+ (void)injectViewSearchIntoEvent:(ALTEvent *)event checkInDate:(NSString *)din checkOutDate:(NSString *)dout {
    [event addPartnerParameter:@"din" value:din];
    [event addPartnerParameter:@"dout" value:dout];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectViewListingIntoEvent:(ALTEvent *)event productIds:(NSArray *)productIds {
    NSString *jsonProductsIds = [ALTCriteo createCriteoVLFromProducts:productIds];
    [event addPartnerParameter:@"criteo_p" value:jsonProductsIds];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectViewProductIntoEvent:(ALTEvent *)event productId:(NSString *)productId {
    [event addPartnerParameter:@"criteo_p" value:productId];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectCartIntoEvent:(ALTEvent *)event products:(NSArray *)products {
    NSString *jsonProducts = [ALTCriteo createCriteoVBFromProducts:products];
    [event addPartnerParameter:@"criteo_p" value:jsonProducts];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectTransactionConfirmedIntoEvent:(ALTEvent *)event
                                   products:(NSArray *)products
                              transactionId:(NSString *)transactionId
                                newCustomer:(NSString *)newCustomer {
    [event addPartnerParameter:@"transaction_id" value:transactionId];

    NSString *jsonProducts = [ALTCriteo createCriteoVBFromProducts:products];
    [event addPartnerParameter:@"criteo_p" value:jsonProducts];
    [event addPartnerParameter:@"new_customer" value:newCustomer];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectUserLevelIntoEvent:(ALTEvent *)event uiLevel:(NSUInteger)uiLevel {
    NSString *uiLevelString = [NSString stringWithFormat:@"%lu",(unsigned long)uiLevel];
    [event addPartnerParameter:@"ui_level" value:uiLevelString];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectUserStatusIntoEvent:(ALTEvent *)event uiStatus:(NSString *)uiStatus {
    [event addPartnerParameter:@"ui_status" value:uiStatus];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectAchievementUnlockedIntoEvent:(ALTEvent *)event uiAchievement:(NSString *)uiAchievement {
    [event addPartnerParameter:@"ui_achievmnt" value:uiAchievement];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectCustomEventIntoEvent:(ALTEvent *)event uiData:(NSString *)uiData {
    [event addPartnerParameter:@"ui_data" value:uiData];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectCustomEvent2IntoEvent:(ALTEvent *)event uiData2:(NSString *)uiData2 uiData3:(NSUInteger)uiData3 {
    [event addPartnerParameter:@"ui_data2" value:uiData2];

    NSString *uiData3String = [NSString stringWithFormat:@"%lu",(unsigned long)uiData3];
    [event addPartnerParameter:@"ui_data3" value:uiData3String];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectDeeplinkIntoEvent:(ALTEvent *)event url:(NSURL *)url {
    if (url == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_deeplink" value:[url absoluteString]];

    [ALTCriteo injectOptionalParams:event];
}

+ (void)injectHashedEmailIntoCriteoEvents:(NSString *)hashEmail {
    hashEmailInternal = hashEmail;
}

+ (void)injectViewSearchDatesIntoCriteoEvents:(NSString *)checkInDate checkOutDate:(NSString *)checkOutDate {
    checkInDateInternal = checkInDate;
    checkOutDateInternal = checkOutDate;
}

+ (void)injectPartnerIdIntoCriteoEvents:(NSString *)partnerId {
    partnerIdInternal = partnerId;
}

+ (void)injectUserSegmentIntoCriteoEvents:(NSString *)userSegment {
    userSegmentInternal = userSegment;
}

+ (void)injectCustomerIdIntoCriteoEvents:(NSString *)customerId {
    customerIdInternal = customerId;
}

+ (void)injectOptionalParams:(ALTEvent *)event {
    [ALTCriteo injectHashEmail:event];
    [ALTCriteo injectSearchDates:event];
    [ALTCriteo injectPartnerId:event];
    [ALTCriteo injectUserSegment:event];
    [ALTCriteo injectCustomerId:event];
}

+ (void)injectHashEmail:(ALTEvent *)event {
    if (hashEmailInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_email_hash" value:hashEmailInternal];
}

+ (void)injectSearchDates:(ALTEvent *)event {
    if (checkInDateInternal == nil || checkOutDateInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"din" value:checkInDateInternal];
    [event addPartnerParameter:@"dout" value:checkOutDateInternal];
}

+ (void)injectPartnerId:(ALTEvent *)event {
    if (partnerIdInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_partner_id" value:partnerIdInternal];
}

+ (void)injectUserSegment:(ALTEvent *)event {
    if (userSegmentInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"user_segment" value:userSegmentInternal];
}

+ (void)injectCustomerId:(ALTEvent *)event {
    if (customerIdInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"customer_id" value:customerIdInternal];
}

+ (NSString *)createCriteoVBFromProducts:(NSArray *)products {
    if (products == nil) {
        [self.logger warn:@"Criteo Event product list is nil. It will sent as empty."];
        products = @[];
    }

    NSUInteger productsCount = [products count];
    NSMutableString *criteoVBValue = [NSMutableString stringWithString:@"["];
    
    for (NSUInteger i = 0; i < productsCount;) {
        id productAtIndex = [products objectAtIndex:i];

        if (![productAtIndex isKindOfClass:[ALTCriteoProduct class]]) {
            [self.logger error:@"Criteo Event should contain a list of ALTCriteoProduct"];
            return nil;
        }

        ALTCriteoProduct *product = (ALTCriteoProduct *)productAtIndex;
        NSString *productString = [NSString stringWithFormat:@"{\"i\":\"%@\",\"pr\":%f,\"q\":%lu}",
                                   [product criteoProductID],
                                   [product criteoPrice],
                                   (unsigned long)[product criteoQuantity]];

        [criteoVBValue appendString:productString];

        i++;

        if (i == productsCount) {
            break;
        }

        [criteoVBValue appendString:@","];
    }

    [criteoVBValue appendString:@"]"];

    return [criteoVBValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)createCriteoVLFromProducts:(NSArray *)productIds {
    if (productIds == nil) {
        [self.logger warn:@"Criteo View Listing product ids list is nil. It will sent as empty."];
        productIds = @[];
    }

    NSUInteger productsIdCount = [productIds count];

    if (productsIdCount > MAX_VIEW_LISTING_PRODUCTS) {
        [self.logger warn:@"Criteo View Listing should only have at most 3 product ids. The rest will be discarded."];
    }

    NSMutableString *criteoVLValue = [NSMutableString stringWithString:@"["];

    for (NSUInteger i = 0; i < productsIdCount;) {
        id productAtIndex = [productIds objectAtIndex:i];
        NSString *productId;
        
        if ([productAtIndex isKindOfClass:[NSString class]]) {
            productId = productAtIndex;
        } else if ([productAtIndex isKindOfClass:[ALTCriteoProduct class]]) {
            ALTCriteoProduct *criteoProduct = (ALTCriteoProduct *)productAtIndex;
            productId = [criteoProduct criteoProductID];
            
            [self.logger warn:@"Criteo View Listing should contain a list of product ids, not of ALTCriteoProduct. Reading the product id of the ALTCriteoProduct."];
        } else {
            return nil;
        }

        NSString *productIdEscaped = [NSString stringWithFormat:@"\"%@\"", productId];

        [criteoVLValue appendString:productIdEscaped];

        i++;

        if (i == productsIdCount || i >= MAX_VIEW_LISTING_PRODUCTS) {
            break;
        }

        [criteoVLValue appendString:@","];
    }

    [criteoVLValue appendString:@"]"];

    return [criteoVLValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
