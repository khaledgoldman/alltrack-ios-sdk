#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import "AlltrackBridgeRegister.h"

@interface AlltrackBridge : NSObject

@property (nonatomic, strong, readonly) AlltrackBridgeRegister *bridgeRegister;

- (void)loadWKWebViewBridge:(WKWebView *)wkWebView;
- (void)loadWKWebViewBridge:(WKWebView *)wkWebView wkWebViewDelegate:(id<WKNavigationDelegate>)wkWebViewDelegate;
- (void)augmentHybridWebView;

@end
