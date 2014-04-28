#import "Kiwi.h"
#import "CTGeneralMessage.h"


SPEC_BEGIN(CTGeneralMessageSpec)

        describe(@"CTGeneralMessage", ^{

            it(@"can join", ^{
                CTGeneralMessage *message1 = [[CTGeneralMessage alloc] initWithContent:@"message 1" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];
                CTGeneralMessage *message2 = [[CTGeneralMessage alloc] initWithContent:@"message 2" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];

                [[theValue([message1 canJoinMessage:message2]) should] beTrue];
            });

            it(@"cannot join", ^{
                CTGeneralMessage *message1 = [[CTGeneralMessage alloc] initWithContent:@"message 1" subContent:nil canJoinOtherMessage:NO type:CTGeneralMessageTypeNormal];
                CTGeneralMessage *message2 = [[CTGeneralMessage alloc] initWithContent:@"message 2" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];

                [[theValue([message1 canJoinMessage:message2]) should] beFalse];

                message1 = [[CTGeneralMessage alloc] initWithContent:@"message 1" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];
                message2 = [[CTGeneralMessage alloc] initWithContent:@"message 2" subContent:nil canJoinOtherMessage:NO type:CTGeneralMessageTypeNormal];

                [[theValue([message1 canJoinMessage:message2]) should] beFalse];

                message1 = [[CTGeneralMessage alloc] initWithContent:@"message 1" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];
                message2 = [[CTGeneralMessage alloc] initWithContent:@"message 2" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeError];

                [[theValue([message1 canJoinMessage:message2]) should] beFalse];
            });

        });

SPEC_END
