//
//  WKWebViewController.h
//  AlltrackExample-WebView
//
//  Created by Uglješa Erceg (@uerceg) on 31st May 2016.
//  Copyright © 2016-Present Alltrack GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "AlltrackBridge.h"

@interface WKWebViewController : UINavigationController<WKNavigationDelegate, WKUIDelegate>

@property AlltrackBridge *alltrackBridge;

@end
