//
//  CTJoinMessage.m
//
//  Created by Ryoichi Izumita on 2014/04/22.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import "CTJoinMessage.h"

@implementation CTJoinMessage
@synthesize joinedMessages = _joinedMessages;

- (id)init
{
    self = [super init];
    if (self) {
        _joinedMessages = [NSMutableArray array];
    }
    return self;
}

- (NSString *)content
{
    return [[_joinedMessages valueForKeyPath:@"@unionOfObjects.content"] componentsJoinedByString:@"\n"];
}

- (NSTimeInterval)duration
{
    __block NSTimeInterval duration = 0.0;

    [self.joinedMessages enumerateObjectsUsingBlock:^(CTAbstractMessage *message, NSUInteger idx, BOOL *stop) {
        duration = message.duration > duration ? message.duration : duration;
    }];

    return duration;
}

- (BOOL)canJoinOtherMessage
{
    return YES;
}

- (BOOL)canJoinMessage:(CTAbstractMessage *)message
{
    if (self.joinedMessages.count == 0) return NO;

    return [self.joinedMessages.firstObject canJoinMessage:message];
}

- (CTJoinMessage *)joinMessage:(CTAbstractMessage *)message
{
    [self willChangeValueForKey:@"joinedMessages"];
    [(NSMutableArray *)_joinedMessages addObject:message];
    [self didChangeValueForKey:@"joinedMessages"];

    return self;
}

@end
