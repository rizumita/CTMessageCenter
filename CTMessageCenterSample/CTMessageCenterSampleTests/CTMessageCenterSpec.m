#import "CTJoinMessage.h"
#import "Kiwi.h"
#import "CTMessageCenter.h"
#import "CTAbstractMessage.h"
#import "CTGeneralMessage.h"


SPEC_BEGIN(CTMessageCenterSpec)

        describe(@"CTMessageCenter", ^{

            it(@"should show and hide a message", ^{
                CTMessageCenter *messageCenter = [CTMessageCenter defaultCenter];
                messageCenter.showingDuration = 0.5;

                __block BOOL successShowing = NO;
                messageCenter.showMessageBlock = ^(CTAbstractMessage *message) {
                    [[message.content should] equal:@"show hide message"];

                    successShowing = YES;
                };

                __block BOOL successHiding = NO;
                messageCenter.hideMessageBlock = ^(CTAbstractMessage *message) {
                    successHiding = YES;
                };

                [messageCenter addMessage:@"show hide message"];

                [[expectFutureValue(theValue(successShowing)) shouldEventuallyBeforeTimingOutAfter(1.0)] beTrue];

                [[expectFutureValue(theValue(successHiding)) shouldEventuallyBeforeTimingOutAfter(1.0)] beTrue];

                [[expectFutureValue(messageCenter.enqueuedMessages) shouldEventuallyBeforeTimingOutAfter(1.0)] beEmpty];
            });

            it(@"should join messages", ^{
                CTMessageCenter *messageCenter = [CTMessageCenter defaultCenter];
                messageCenter.showingDelay = 0.5;

                __block CTAbstractMessage *showedMessage = nil;
                messageCenter.showMessageBlock = ^(CTAbstractMessage *message) {
                    if (!showedMessage) showedMessage = message;
                };

                CTGeneralMessage *firstMessage = [[CTGeneralMessage alloc] initWithContent:@"first message" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];
                [messageCenter addMessage:firstMessage];

                [messageCenter addMessage:@"second message"];

                [messageCenter addErrorMessage:@"error message"];

                [messageCenter addMessage:@"third message"];

                [[expectFutureValue(((CTJoinMessage *)showedMessage).content) shouldEventuallyBeforeTimingOutAfter(1.0)] equal:@"first message\nsecond message"];
            });
        });

        SPEC_END
