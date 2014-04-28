//
//  CTAbstractMessage.h
//
//  Created by Ryoichi Izumita on 2014/04/22.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTJoinMessage;

@interface CTAbstractMessage : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *subContent;

/**
    If 0, CTMessageCenter use CTMessageCenter.showingDuration
*/
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) BOOL canJoinOtherMessage;

- (instancetype)initWithContent:(NSString *)content
                     subContent:(NSString *)subContent
                       duration:(NSTimeInterval)duration
            canJoinOtherMessage:(BOOL)canJoinOtherMessage;

- (BOOL)canJoinMessage:(CTAbstractMessage *)message;

- (CTJoinMessage *)joinMessage:(CTAbstractMessage *)message;

@end
