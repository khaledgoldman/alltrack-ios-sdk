#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "AlltrackBridge.h"

@interface WKWebViewController : UIViewController

@property AlltrackBridge *alltrackBridge;
@property JSContext *jsContext;

@end
