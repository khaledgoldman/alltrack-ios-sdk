//
//  AlltrackWebViewJSBridge.h
//  Alltrack SDK
//
//  Created by Pedro Filipe (@nonelse) on 10th June 2016.
//  Copyright © 2016-2018 Alltrack GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebViewJavascriptBridge.h"

@interface AlltrackBridgeRegister : NSObject

+ (NSString *)AlltrackBridge_js;

- (id)initWithWKWebView:(WKWebView*)webView;
- (void)setWKWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate;
- (void)callHandler:(NSString *)handlerName data:(id)data;
- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;
- (void)augmentHybridWebView:(NSString *)fbAppId;

@end
