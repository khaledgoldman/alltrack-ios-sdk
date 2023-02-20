
#import "WKWebViewController.h"

@interface WKWebViewController ()<WKNavigationDelegate>

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadWKWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadWKWebView {
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _alltrackBridge = [[AlltrackBridge alloc] init];
    [_alltrackBridge loadWKWebViewBridge:wkWebView wkWebViewDelegate:self];
    [_alltrackBridge augmentHybridWebView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AlltrackExample-FbPixel" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [wkWebView loadRequest:request];
    [self.view addSubview:wkWebView];
}

@end
