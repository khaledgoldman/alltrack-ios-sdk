#import "ALTTrademob.h"
#import "ALTAlltrackFactory.h"

static const NSUInteger MAX_LISTING_ITEMS_COUNT = 5;

@implementation ALTTrademobItem

- (instancetype)initWithId:(NSString *)itemId price:(float)price quantity:(NSUInteger)quantity {
    self = [super init];
    
    if (self) {
        self.itemId = itemId;
        self.price = price;
        self.quantity = quantity;
    }

    return self;
}

+ (NSDictionary *)dictionaryFromItem:(ALTTrademobItem *)item {
    return @{@"itemId": item.itemId,
             @"price": [NSNumber numberWithFloat:item.price],
             @"quantity":[NSNumber numberWithUnsignedInteger:item.quantity]};
}

@end

@implementation ALTTrademob

+ (void)injectViewListingIntoEvent:(ALTEvent *)event
                           itemIds:(NSArray *)itemIds
                          metadata:(NSDictionary *)metadata {
    [event addPartnerParameter:@"tm_item" value:[ALTTrademob stringifyItemIds:itemIds]];
    [event addPartnerParameter:@"tm_md" value:[ALTTrademob stringifyMetadata:metadata]];
}

+ (void)injectViewItemIntoEvent:(ALTEvent *)event
                         itemId:(NSString *)itemId
                       metadata:(NSDictionary *)metadata {
    [event addPartnerParameter:@"tm_item" value:itemId];
    [event addPartnerParameter:@"tm_md" value:[ALTTrademob stringifyMetadata:metadata]];
}

+ (void)injectAddToBasketIntoEvent:(ALTEvent *)event
                             items:(NSArray *)items
                          metadata:(NSDictionary *)metadata {
    [event addPartnerParameter:@"tm_item" value:[ALTTrademob stringifyItems:items]];
    [event addPartnerParameter:@"tm_md" value:[ALTTrademob stringifyMetadata:metadata]];
}

+ (void)injectCheckoutIntoEvent:(ALTEvent *)event
                          items:(NSArray *)items
                       metadata:(NSDictionary *)metadata {
    [event addPartnerParameter:@"tm_item" value:[ALTTrademob stringifyItems:items]];
    [event addPartnerParameter:@"tm_md" value:[ALTTrademob stringifyMetadata:metadata]];
}

# pragma private helper functions

+ (NSString *)stringifyItemIds:(NSArray *)itemIds {
    NSUInteger length = [itemIds count];
    NSMutableArray *filteredArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < length; ++index) {
        if (index >= MAX_LISTING_ITEMS_COUNT) {
            break;
        }

        NSObject *currentId = itemIds[index];

        if ([currentId isKindOfClass:[NSString class]] && ![(NSString *)currentId isEqualToString:@""]) {
            [filteredArray addObject:currentId];
        }
    }

    NSString *tmItemIds = [ALTTrademob stringify:filteredArray];

    if (nil == tmItemIds) {
        tmItemIds = @"[]";
    }

    return [tmItemIds stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
}

+ (NSString *)stringifyItems:(NSArray *)items {
    NSUInteger length = [items count];
    NSMutableArray *filteredItems = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < length; ++index) {
        if (index >= MAX_LISTING_ITEMS_COUNT) {
            break;
        }
        
        ALTTrademobItem *currentItem = items[index];

        if ([currentItem isKindOfClass:[ALTTrademobItem class]]) {
            NSDictionary *dict = [ALTTrademobItem dictionaryFromItem:currentItem];
            [filteredItems addObject:dict];
        }
    }
    
    NSString *tmItemIds = [ALTTrademob stringify:filteredItems];
    
    if (nil == tmItemIds) {
        tmItemIds = @"[]";
    }
    
    return [tmItemIds stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
}

+ (NSString *)stringifyMetadata: (NSDictionary *)metadata {
    NSMutableDictionary *filteredData = [NSMutableDictionary dictionary];
    
    [metadata enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        if ([value isKindOfClass:[NSString class]]) {
            filteredData[key] = value;
        }
    }];
    
    NSString *jsonMetaData = [ALTTrademob stringify:filteredData];
    
    if (nil == jsonMetaData) {
        jsonMetaData = @"{}";
    }
    
    return [jsonMetaData stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
}

+ (NSString *)stringify:(NSObject *)object {
    if (nil == object) {
        return nil;
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    
    if (!jsonData || error) {
        [ALTAlltrackFactory.logger error:@"%@", [error debugDescription]];
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
