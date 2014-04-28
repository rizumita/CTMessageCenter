//
//  CTGeneralMessage.m
//
//  Created by Ryoichi Izumita on 2014/04/22.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import "CTGeneralMessage.h"

@implementation CTGeneralMessage

- (instancetype)initWithContent:(NSString *)content subContent:(NSString *)subContent
            canJoinOtherMessage:(BOOL)canJoinOtherMessage type:(CTGeneralMessageType)type
{
    self = [super initWithContent:content subContent:subContent duration:0 canJoinOtherMessage:canJoinOtherMessage];
    if (self) {
        _type = type;
    }
    return self;
}

- (BOOL)canJoinMessage:(CTAbstractMessage *)message
{
    BOOL canJoin = [super canJoinMessage:message];
    if (!canJoin) return NO;

    return self.type == ((CTGeneralMessage *)message).type;
}

@end
