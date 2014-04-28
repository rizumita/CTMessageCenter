//
//  CTMessageCenter.h
//
//  Created by Ryoichi Izumita on 2014/04/20.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTAbstractMessage;


@interface CTMessageCenter : NSObject

@property (nonatomic, readonly) NSArray *enqueuedMessages;

@property (nonatomic, readonly) NSArray *dequeuedMessages;

/**
    Default is 10;
*/
@property (nonatomic) NSUInteger dequeuedMessagesKeepCount;

/**
    Delay after adding a message. Default is 0.
*/
@property (nonatomic) NSTimeInterval showingDelay;

/**
    Duration for showing message. Default is 5.0.
 */
@property (nonatomic) NSTimeInterval showingDuration;

@property (nonatomic, copy) void (^showMessageBlock)(CTAbstractMessage *message);

@property (nonatomic, copy) void (^hideMessageBlock)(CTAbstractMessage *message);


+ (CTMessageCenter *)defaultCenter;

- (void)setShowMessageBlock:(void (^)(CTAbstractMessage *message))showMessageBlock
           hideMessageBlock:(void (^)(CTAbstractMessage *message))hideMessageBlock
                   forClass:(Class)targetClass;

/*
    @param message NSString or message object. If it is a kind of NSString, it convert to CTGeneralMessage object with CTGeneralMessageTypeNormal type
 */
- (void)addMessage:(id)message;

/*
    @param message NSString or message object. If it is a kind of NSString, it convert to CTGeneralMessage object with CTGeneralMessageTypeError type.
 */
- (void)addErrorMessage:(id)message;

- (void)reset;

@end
