#import "Kiwi.h"
#import "CTGeneralMessage.h"
#import "CTJoinMessage.h"


SPEC_BEGIN(CTJoinMessageSpec)

        describe(@"CTJoinMessage", ^{

            it(@"join", ^{
                CTGeneralMessage *generalMessage1 = [[CTGeneralMessage alloc] initWithContent:@"general message 1" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];
                CTGeneralMessage *generalMessage2 = [[CTGeneralMessage alloc] initWithContent:@"general message 2" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];

                CTJoinMessage *joinMessage = [generalMessage1 joinMessage:generalMessage2];
                [[joinMessage should] beMemberOfClass:[CTJoinMessage class]];
                [[joinMessage.joinedMessages should] haveCountOf:2];

                CTGeneralMessage *generalMessage3 = [[CTGeneralMessage alloc] initWithContent:@"general message 3" subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal];

                [[theValue([joinMessage canJoinMessage:generalMessage3]) should] beTrue];

                joinMessage = [joinMessage joinMessage:generalMessage3];
                [[joinMessage should] beMemberOfClass:[CTJoinMessage class]];
                [[joinMessage.joinedMessages should] haveCountOf:3];
            });

        });

        SPEC_END
