#import <Foundation/Foundation.h>

#import "Alltrack.h"

///----------------------------
/// @name Sociomantic Aliases
///----------------------------

extern NSString * __nonnull const SCMCategory;
extern NSString * __nonnull const SCMProductName;
extern NSString * __nonnull const SCMSalePrice;
extern NSString * __nonnull const SCMAmount;
extern NSString * __nonnull const SCMCurrency;
extern NSString * __nonnull const SCMProductURL;
extern NSString * __nonnull const SCMProductImageURL;
extern NSString * __nonnull const SCMBrand;
extern NSString * __nonnull const SCMDescription;
extern NSString * __nonnull const SCMTimestamp;
extern NSString * __nonnull const SCMValidityTimestamp;
extern NSString * __nonnull const SCMQuantity;
extern NSString * __nonnull const SCMScore;
extern NSString * __nonnull const SCMProductID;
extern NSString * __nonnull const SCMAmount;
extern NSString * __nonnull const SCMCurrency;
extern NSString * __nonnull const SCMQuantity;
extern NSString * __nonnull const SCMAmount;
extern NSString * __nonnull const SCMCurrency;
extern NSString * __nonnull const SCMActionConfirmed;
extern NSString * __nonnull const SCMActionConfirmed;
extern NSString * __nonnull const SCMCustomerAgeGroup;
extern NSString * __nonnull const SCMCustomerEducation;
extern NSString * __nonnull const SCMCustomerGender;
extern NSString * __nonnull const SCMCustomerID;
extern NSString * __nonnull const SCMCustomerMHash;
extern NSString * __nonnull const SCMCustomerSegment;
extern NSString * __nonnull const SCMCustomerTargeting;

///--------------------------------
/// @name Alltrack Sociomantic Events
///--------------------------------

/**
 * Object exposing the different methods of the Sociomantic plugin for Alltrack.
 */
@interface ALTSociomantic : NSObject

/**
 * Methods uses the given string, stores it into a singleton, it'll be injected into every
 * further sociomantic event.
 *
 * @param   adpanId           `NSString`
 *
 */
+ (void)injectPartnerIdIntoSociomanticEvents:(nullable NSString *)adpanId;

/**
 * Methods uses the given dictionary, filters it and injects it into the event.
 *
 * @param   event           `ALTEvent`
 * @param   data            `NSDictionary`
 *
 */
+ (void)injectCustomerDataIntoEvent:(nullable ALTEvent *)event
                           withData:(nullable NSDictionary *)data;


/**
 * Method makes sure the event has the adpanId into the event.
 *
 * @param   event           `ALTEvent`
 *
 */
+ (void)addPartnerParameter:(nullable ALTEvent *)event;


/**
 * Method makes sure the event has the adpanId into the event and injects the json 
 * value into the partner parameter.
 *
 * @param   event           `ALTEvent`
 *
 */
+ (void)addPartnerParameter:(nullable ALTEvent *)event
                  parameter:(nullable NSString *)parameterName
                      value:(nullable NSString *)jsonValue;

/**
 * Method injects a home page view into an Alltrack event.
 *
 * @param   event           `ALTEvent`
 *
 */
+ (void)injectHomePageIntoEvent:(nullable ALTEvent *)event;


/**
 * Method injects a category page view into an Alltrack event.
 *
 * Note: the category array will be filtered to only contain strings.
 *
 * @param   event           `ALTEvent`
 * @param   categories      `NSArray`
 *
 */
+ (void)injectViewListingIntoEvent:(nullable ALTEvent *)event
                    withCategories:(nullable NSArray *)categories;

/**
 * Method injects a category page view into an Alltrack event.
 *
 * Note: the category array will be filtered to only contain strings.
 *
 * @param   event           `ALTEvent`
 * @param   categories      `NSArray`
 * @param   date            `NSString`
 *
 */
+ (void)injectViewListingIntoEvent:(nullable ALTEvent *)event
                    withCategories:(nullable NSArray *)categories
                          withDate:(nullable NSString *)date;

/**
 * Method injects a product page view into an Alltrack event.
 *
 * @param   event           `ALTEvent`
 * @param   productId       `NSString`
 *
 */
+ (void)injectViewProductIntoEvent:(nullable ALTEvent *)event
                         productId:(nullable NSString *)productId;

/**
 * Method injects a product page view into an Alltrack event.
 * Parameters dictionary will be filtered by keys and only keep the key-value
 * pairs where the key can be found in the
 * `SCMSingleton.properties[@"product"]` dictionary. These keys can be also
 * found in the file `SCMAliases.h`.
 *
 * @param   event           `ALTEvent`
 * @param   productId       `NSString`
 * @param   parameters      `NSDictionary`
 *
 */
+ (void)injectViewProductIntoEvent:(nullable ALTEvent *)event
                         productId:(nullable NSString *)productId
                    withParameters:(nullable NSDictionary *)parameters;

/**
 * Method injects a basket page view. The basket into an Alltrack event.
 * used to create the request is the given array of products.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 *
 * @param   event           `ALTEvent`
 * @param   products        `NSArray`
 *
 */
+ (void)injectCartIntoEvent:(nullable ALTEvent *)event
                       cart:(nullable NSArray *)products;


/**
 * Method injects a confirmed sale page view into an Alltrack event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 *
 * @param   event           `ALTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 *
 */
+ (void)injectConfirmedTransactionIntoEvent:(nullable ALTEvent *)event
                              transactionId:(nullable NSString *)transactionID
                               withProducts:(nullable NSArray *)products;

/**
 * Method injects a confirmed sale page view into an Alltrack event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 * The same thing for the transaction option parameters, they are filtered
 * according to SCMSingleton.properties[@"sale"]`
 *
 * @param   event           `ALTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 * @param   parameters      `NSDictionary`
 *
 */
+ (void)injectConfirmedTransactionIntoEvent:(nullable ALTEvent *)event
                              transactionId:(nullable NSString *)transactionID
                               withProducts:(nullable NSArray *)products
                             withParameters:(nullable NSDictionary *)parameters;

/**
 * Method injects a non-confirmed sale page view into an Alltrack event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 * The same thing for the transaction option parameters, they are filtered
 * according to SCMSingleton.properties[@"sale"]`
 *
 * @param   event           `ALTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 *
 */
+ (void)injectTransactionIntoEvent:(nullable ALTEvent *)event
                     transactionId:(nullable NSString *)transactionID
                      withProducts:(nullable NSArray *)products;
/**
 * Method injects a sale page view into an Alltrack event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 * The same thing for the transaction option parameters, they are filtered
 * according to SCMSingleton.properties[@"sale"]`
 *
 * @param   event           `ALTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 * @param   parameters      `NSDictionary`
 *
 */
+ (void)injectTransactionIntoEvent:(nullable ALTEvent *)event
                     transactionId:(nullable NSString *)transactionID
                      withProducts:(nullable NSArray *)products
                    withParameters:(nullable NSDictionary *)parameters;

/**
 * Method injects a lead page into an Alltrack event.
 *
 * @param   event           `ALTEvent`
 * @param   transactionID   `NSString`
 *
 */
+ (void)injectLeadIntoEvent:(nullable ALTEvent *)event
                     leadID:(nullable NSString *)transactionID;

/**
 * Method injects a lead page into an Alltrack event.
 * It can be confirmed or not.
 *
 * @param   event           `ALTEvent`
 * @param   transactionID   `NSString`
 *
 */
+ (void)injectLeadIntoEvent:(nullable ALTEvent *)event
                     leadID:(nullable NSString *)transactionID
               andConfirmed:(BOOL)confirmed;

@end
