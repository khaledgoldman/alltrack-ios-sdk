//
//  ViewControllerWatch.m
//  AlltrackExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Alltrack GmbH. All rights reserved.
//

#import "Alltrack.h"
#import "ViewControllerWatch.h"
#import "AlltrackTrackingHelper.h"

@interface ViewControllerWatch ()

@property (weak, nonatomic) IBOutlet UIButton *btnTrackSimpleEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackRevenueEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackEventWithCallback;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackEventWithPartner;

@end

@implementation ViewControllerWatch

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)btnTrackSimpleEventTapped:(UIButton *)sender {
    [[AlltrackTrackingHelper sharedInstance] trackSimpleEvent];
}
- (IBAction)btnTrackRevenueEventTapped:(UIButton *)sender {
    [[AlltrackTrackingHelper sharedInstance] trackRevenueEvent];
}
- (IBAction)btnTrackCallbackEventTapped:(UIButton *)sender {
    [[AlltrackTrackingHelper sharedInstance] trackCallbackEvent];
}
- (IBAction)btnTrackPartnerEventTapped:(UIButton *)sender {
    [[AlltrackTrackingHelper sharedInstance] trackPartnerEvent];
}

@end
