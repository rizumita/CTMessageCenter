//
//  CTViewController.m
//  CTMessageCenterSample
//
//  Created by Ryoichi Izumita on 2014/04/20.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import "CTViewController.h"
#import "CTMessageCenter.h"
#import "TSMessage.h"
#import "CTAbstractMessage.h"
#import "CTErrorMessage.h"
#import "CTGeneralMessage.h"
#import "CTJoinMessage.h"

@interface CTViewController ()
@property (nonatomic, strong) CTMessageCenter *messageCenter;

- (IBAction)showGeneralMessages:(id)sender;

- (IBAction)showErrorMessages:(id)sender;

- (IBAction)showGeneralAndErrorMessages:(id)sender;
@end

@implementation CTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.messageCenter = [CTMessageCenter defaultCenter];
    self.messageCenter.showingDelay = 0.8;
    self.messageCenter.showMessageBlock = ^(CTAbstractMessage *message) {
        [TSMessage showNotificationInViewController:self title:message.content subtitle:nil image:nil type:[message isKindOfClass:[CTErrorMessage class]] ? TSMessageNotificationTypeError : TSMessageNotificationTypeMessage duration:TSMessageNotificationDurationAutomatic callback:nil buttonTitle:nil buttonCallback:nil atPosition:TSMessageNotificationPositionTop canBeDismissedByUser:YES];
    };
    [self.messageCenter setShowMessageBlock:(void (^)(CTAbstractMessage *))^(CTGeneralMessage *message) {
        [TSMessage showNotificationInViewController:self
                                              title:message.content
                                           subtitle:nil
                                              image:nil
                                               type:message.type == CTGeneralMessageTypeError ? TSMessageNotificationTypeError : TSMessageNotificationTypeMessage
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    }                      hideMessageBlock:nil forClass:[CTGeneralMessage class]];
    [self.messageCenter setShowMessageBlock:^(CTAbstractMessage *message) {
        [TSMessage showNotificationInViewController:self
                                              title:message.content
                                           subtitle:nil
                                              image:nil
                                               type:TSMessageNotificationTypeError
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    }                      hideMessageBlock:nil forClass:[CTErrorMessage class]];
    [self.messageCenter setShowMessageBlock:(void (^)(CTAbstractMessage *))^(CTJoinMessage *message) {
        [TSMessage showNotificationInViewController:self
                                              title:message.content
                                           subtitle:nil
                                              image:nil
                                               type:[message.joinedMessages[0] isKindOfClass:[CTErrorMessage class]] ? TSMessageNotificationTypeError : TSMessageNotificationTypeMessage
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    }                      hideMessageBlock:nil forClass:[CTJoinMessage class]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showGeneralMessages:(id)sender
{
    [self.messageCenter addMessage:@"first message"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.messageCenter addMessage:@"second message"];
        [self.messageCenter addMessage:@"third message"];
    });
}

- (IBAction)showErrorMessages:(id)sender
{
    [self.messageCenter addMessage:[[CTErrorMessage alloc] initWithError:[NSError errorWithDomain:@"SampleDomain" code:0 userInfo:@{NSLocalizedDescriptionKey : @"first error message"}] duration:0 canJoinOtherMessage:NO ]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.messageCenter addErrorMessage:@"second error message"];
        [self.messageCenter addErrorMessage:@"third error message"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.messageCenter addErrorMessage:[[CTErrorMessage alloc] initWithError:[NSError errorWithDomain:@"SampleDomain" code:0 userInfo:@{NSLocalizedDescriptionKey : @"fourth error message"}] duration:0 canJoinOtherMessage:YES ]];
            [self.messageCenter addErrorMessage:[[CTErrorMessage alloc] initWithError:[NSError errorWithDomain:@"SampleDomain" code:0 userInfo:@{NSLocalizedDescriptionKey : @"fifth error message"}] duration:0 canJoinOtherMessage:YES ]];
        });
    });
}

- (IBAction)showGeneralAndErrorMessages:(id)sender
{
    [self.messageCenter addMessage:@"first message"];
    [self.messageCenter addErrorMessage:@"first error message"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.messageCenter addErrorMessage:@"second error message"];
        [self.messageCenter addMessage:@"second message"];
        [self.messageCenter addErrorMessage:@"third error message"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.messageCenter addMessage:[[CTErrorMessage alloc] initWithError:[NSError errorWithDomain:@"SampleDomain" code:0 userInfo:@{NSLocalizedDescriptionKey : @"fourth error message"}] duration:0 canJoinOtherMessage:YES ]];
            [self.messageCenter addMessage:[[CTErrorMessage alloc] initWithError:[NSError errorWithDomain:@"SampleDomain" code:0 userInfo:@{NSLocalizedDescriptionKey : @"fifth error message"}] duration:0 canJoinOtherMessage:YES ]];
        });
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.messageCenter addMessage:@"third message"];
    });
}

@end
