//
//  CTMessageCenter.m
//
//  Created by Ryoichi Izumita on 2014/04/20.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import "CTMessageCenter.h"
#import "CTAbstractMessage.h"
#import "CTGeneralMessage.h"
#import "CTJoinMessage.h"


static const int CTMessageCenterDefaultDequeuedMessageKeepCount = 10;

static const float CTMessageCenterDefaultShowingDuration = 5.0;

@interface CTMessageCenter ()
@property (nonatomic, strong) NSMutableArray *internalEnqueuedMessages;
@property (nonatomic, strong) NSMutableArray *internalDequeuedMessages;
@property (nonatomic, strong) NSMutableDictionary *showMessageBlockDictionary;
@property (nonatomic, strong) NSMutableDictionary *hideMessageBlockDictionary;
@end

@implementation CTMessageCenter

+ (CTMessageCenter *)defaultCenter
{
    static CTMessageCenter *instance;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        instance = [[CTMessageCenter alloc] init];
    });

    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.internalEnqueuedMessages = [NSMutableArray array];
        self.internalDequeuedMessages = [NSMutableArray array];
        self.dequeuedMessagesKeepCount = CTMessageCenterDefaultDequeuedMessageKeepCount;
        self.showMessageBlockDictionary = [NSMutableDictionary dictionary];
        self.hideMessageBlockDictionary = [NSMutableDictionary dictionary];
        self.showingDuration = CTMessageCenterDefaultShowingDuration;
    }
    return self;
}

#pragma mark - Properties

- (NSArray *)enqueuedMessages
{
    return self.internalEnqueuedMessages.copy;
}

- (NSArray *)dequeuedMessages
{
    return self.internalDequeuedMessages.copy;
}

#pragma mark - Actions

- (void)setShowMessageBlock:(void (^)(CTAbstractMessage *message))showMessageBlock
           hideMessageBlock:(void (^)(CTAbstractMessage *message))hideMessageBlock
                   forClass:(Class)targetClass
{
    [self.showMessageBlockDictionary setObject:[showMessageBlock copy] forKey:NSStringFromClass(targetClass)];
    [self.hideMessageBlockDictionary setObject:[showMessageBlock copy] forKey:NSStringFromClass(targetClass)];
}

- (void)addMessage:(id)message
{
    CTAbstractMessage *messageObject = [message isKindOfClass:[NSString class]] ? [[CTGeneralMessage alloc] initWithContent:message subContent:nil canJoinOtherMessage:YES type:CTGeneralMessageTypeNormal] : message;

    [self enqueueMessage:messageObject];

    [self performSelector:@selector(showMessage) withObject:nil afterDelay:self.showingDelay];
}

- (void)addErrorMessage:(id)message
{
    CTAbstractMessage *messageObject = [message isKindOfClass:[NSString class]] ? [[CTGeneralMessage alloc] initWithContent:message subContent:nil canJoinOtherMessage:NO type:CTGeneralMessageTypeError] : message;

    [self enqueueMessage:messageObject];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMessage) object:self.internalEnqueuedMessages.firstObject];
    [self performSelector:@selector(showMessage) withObject:self.internalEnqueuedMessages.firstObject afterDelay:self.showingDelay];
}

- (void)enqueueMessage:(CTAbstractMessage *)message
{
    @synchronized (self) {
        CTAbstractMessage *lastMessage = self.internalEnqueuedMessages.lastObject;

        if ([lastMessage canJoinMessage:message]) {
            CTJoinMessage *joinMessage = [lastMessage joinMessage:message];
            [self.internalEnqueuedMessages removeObject:lastMessage];
            [self.internalEnqueuedMessages addObject:joinMessage];
            return;
        }

        [self.internalEnqueuedMessages addObject:message];
    }
}

- (CTAbstractMessage *)dequeueMessage
{
    @synchronized (self) {
        CTAbstractMessage *result = self.internalEnqueuedMessages.firstObject;
        if (!result) return nil;

        [self.internalEnqueuedMessages removeObject:result];

        [self.internalDequeuedMessages addObject:result];
        if (self.dequeuedMessagesKeepCount != 0 && self.internalDequeuedMessages.count > self.dequeuedMessagesKeepCount) {
            [self.internalDequeuedMessages removeObjectAtIndex:0];
        }

        return result;
    }
}

- (void)reset
{
    @synchronized (self) {
        [self.internalEnqueuedMessages removeAllObjects];
        [self.internalDequeuedMessages removeAllObjects];
    }
}

- (void)showMessage
{
    if (self.showMessageBlock) {
        CTAbstractMessage *message = [self dequeueMessage];
        if (!message) return;

        void (^block)(CTAbstractMessage *inMessage) = [self.showMessageBlockDictionary objectForKey:NSStringFromClass(message.class)];
        if (block) {
            block(message);
        } else if (self.showMessageBlock) {
            self.showMessageBlock(message);
        }

        NSTimeInterval duration = message.duration > 0 ? message.duration : self.showingDuration;
        NSLog(@"%@", @(duration));
        [self performSelector:@selector(hideMessage:) withObject:message afterDelay:duration];

#ifdef DEBUG
        NSLog(@"Show message: %@", message);
#endif
    }
}

- (void)hideMessage:(CTAbstractMessage *)message
{
    void (^block)(CTAbstractMessage *inMessage) = [self.hideMessageBlockDictionary objectForKey:NSStringFromClass(message.class)];

    if (block) {
        block(message);
    } else if (self.hideMessageBlock) {
        self.hideMessageBlock(message);
    }

    if (self.internalEnqueuedMessages.count > 0) {
        [self showMessage];
    }
}

@end
