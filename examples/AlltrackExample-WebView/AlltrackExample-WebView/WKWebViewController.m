//
//  WKWebViewController.m
//  AlltrackExample-WebView
//
//  Created by Uglješa Erceg (@uerceg) on 31st May 2016.
//  Copyright © 2016-Present Alltrack GmbH. All rights reserved.
//

#import "WKWebViewController.h"

@interface WKWebViewController ()

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
    WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    
    _alltrackBridge = [[AlltrackBridge alloc] init];
    [_alltrackBridge loadWKWebViewBridge:webView wkWebViewDelegate:self];

    // load remote web page
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://alltrackweb.neocities.org"]];
    [webView loadRequest:request];

    // alternative to load web page from local HTML resource
    // NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"AlltrackExample-WebView" ofType:@"html"];
    // NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    // NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    // [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
