//
//  CTGeneralMessage.h
//
//  Created by Ryoichi Izumita on 2014/04/22.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import "CTAbstractMessage.h"


typedef NS_ENUM(NSInteger, CTGeneralMessageType) {
    CTGeneralMessageTypeNormal,
    CTGeneralMessageTypeSuccess,
    CTGeneralMessageTypeError,
    CTGeneralMessageTypeWarning,
};


@interface CTGeneralMessage : CTAbstractMessage


@property (nonatomic) CTGeneralMessageType type;

- (instancetype)initWithContent:(NSString *)content subContent:(NSString *)subContent
            canJoinOtherMessage:(BOOL)canJoinOtherMessage type:(CTGeneralMessageType)type;


@end
