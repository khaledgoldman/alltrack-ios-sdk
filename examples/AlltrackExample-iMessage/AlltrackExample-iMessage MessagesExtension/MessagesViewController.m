//
//  MessagesViewController.m
//  AlltrackExample-iMessage MessagesExtension
//
//  Created by Uglješa Erceg (@uerceg) on 18th of July 2018.
//  Copyright © 2018-Present Alltrack GmbH. All rights reserved.
//

#import "Alltrack.h"
#import "MessagesViewController.h"

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnTrackEvent;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Configure alltrack SDK.
        NSString *yourAppToken = @"2fm9gkqubvpc";
        NSString *environment = ALTEnvironmentSandbox;
        ALTConfig *alltrackConfig = [ALTConfig configWithAppToken:yourAppToken environment:environment];
        
        // Change the log level.
        [alltrackConfig setLogLevel:ALTLogLevelVerbose];
        
        // Add session callback parameters.
        [Alltrack addSessionCallbackParameter:@"sp_foo" value:@"sp_bar"];
        [Alltrack addSessionCallbackParameter:@"sp_key" value:@"sp_value"];
        
        // Add session partner parameters.
        [Alltrack addSessionPartnerParameter:@"sp_foo" value:@"sp_bar"];
        [Alltrack addSessionPartnerParameter:@"sp_key" value:@"sp_value"];
        
        // Remove session callback parameter.
        [Alltrack removeSessionCallbackParameter:@"sp_key"];
        
        // Remove session partner parameter.
        [Alltrack removeSessionPartnerParameter:@"sp_foo"];
        
        // Initialise the SDK.
        [Alltrack appDidLaunch:alltrackConfig];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
    
    [Alltrack trackSubsessionStart];
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
    
    [Alltrack trackSubsessionEnd];
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.
    
    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}

- (IBAction)clickTrackSimpleEvent:(id)sender {
    ALTEvent *event = [ALTEvent eventWithEventToken:@"g3mfiw"];
    [Alltrack trackEvent:event];
}

@end
