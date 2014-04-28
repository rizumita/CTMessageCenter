//
//  CTAbstractMessage.m
//
//  Created by Ryoichi Izumita on 2014/04/22.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import "CTAbstractMessage.h"
#import "CTJoinMessage.h"

@implementation CTAbstractMessage

- (instancetype)initWithContent:(NSString *)content
                     subContent:(NSString *)subContent
                       duration:(NSTimeInterval)duration
            canJoinOtherMessage:(BOOL)canJoinOtherMessage
{
    self = [super init];
    if (self) {
        _content = content;
        _subContent = subContent;
        _duration = duration;
        _canJoinOtherMessage = canJoinOtherMessage;
    }
    return self;
}

- (BOOL)canJoinMessage:(CTAbstractMessage *)message
{
    if (!self.canJoinOtherMessage || !message.canJoinOtherMessage) return NO;

    return [self isMemberOfClass:message.class];
}

- (CTJoinMessage *)joinMessage:(CTAbstractMessage *)message
{
    CTJoinMessage *joinMessage = [[CTJoinMessage alloc] init];
    [joinMessage joinMessage:self];
    [joinMessage joinMessage:message];

    return joinMessage;
}

@end
