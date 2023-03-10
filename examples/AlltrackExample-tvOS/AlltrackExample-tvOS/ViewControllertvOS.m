//
//  ViewControllertvOS.m
//  AlltrackExample-tvOS
//
//  Created by Pedro Filipe (@nonelse) on 12th October 2015.
//  Copyright © 2015-Present Alltrack GmbH. All rights reserved.
//

#import "Alltrack.h"
#import "Constants.h"
#import "ViewControllertvOS.h"

@interface ViewControllertvOS ()

@property (weak, nonatomic) IBOutlet UIButton *btnTrackSimpleEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackRevenueEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackCallbackEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackPartnerEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnEnableOfflineMode;
@property (weak, nonatomic) IBOutlet UIButton *btnDisableOfflineMode;
@property (weak, nonatomic) IBOutlet UIButton *btnEnableSdk;
@property (weak, nonatomic) IBOutlet UIButton *btnDisableSdk;
@property (weak, nonatomic) IBOutlet UIButton *btnIsSdkEnabled;

@end

@implementation ViewControllertvOS

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clickTrackSimpleEvent:(UIButton *)sender {
    ALTEvent *event = [ALTEvent eventWithEventToken:kEventToken1];
    
    [Alltrack trackEvent:event];
}

- (IBAction)clickTrackRevenueEvent:(UIButton *)sender {
    ALTEvent *event = [ALTEvent eventWithEventToken:kEventToken2];
    
    // Add revenue 1 cent of an euro.
    [event setRevenue:0.01 currency:@"EUR"];
    
    [Alltrack trackEvent:event];
}

- (IBAction)clickTrackCallbackEvent:(UIButton *)sender {
    ALTEvent *event = [ALTEvent eventWithEventToken:kEventToken3];
    
    // Add callback parameters to this event.
    [event addCallbackParameter:@"a" value:@"b"];
    [event addCallbackParameter:@"key" value:@"value"];
    [event addCallbackParameter:@"a" value:@"c"];
    
    [Alltrack trackEvent:event];
}

- (IBAction)clickTrackPartnerEvent:(UIButton *)sender {
    ALTEvent *event = [ALTEvent eventWithEventToken:kEventToken4];
    
    // Add partner parameteres to this event.
    [event addPartnerParameter:@"x" value:@"y"];
    [event addPartnerParameter:@"foo" value:@"bar"];
    [event addPartnerParameter:@"x" value:@"z"];
    
    [Alltrack trackEvent:event];
}

- (IBAction)clickEnableOfflineMode:(id)sender {
    [Alltrack setOfflineMode:YES];
}

- (IBAction)clickDisableOfflineMode:(id)sender {
    [Alltrack setOfflineMode:NO];
}

- (IBAction)clickEnableSdk:(id)sender {
    [Alltrack setEnabled:YES];
}

- (IBAction)clickDisableSdk:(id)sender {
    [Alltrack setEnabled:NO];
}

- (IBAction)clickIsSdkEnabled:(id)sender {
    NSString *message;
    if ([Alltrack isEnabled]) {
        message = @"SDK is ENABLED!";
    } else {
        message = @"SDK is DISABLED!";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Is SDK Enabled?"
                                                                   message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
