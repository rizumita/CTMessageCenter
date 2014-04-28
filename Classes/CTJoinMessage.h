//
//  CTJoinMessage.h
//
//  Created by Ryoichi Izumita on 2014/04/22.
//  Copyright (c) 2014 CAPH. All rights reserved.
//


#import "CTAbstractMessage.h"

@interface CTJoinMessage : CTAbstractMessage

@property (nonatomic, strong, readonly) NSArray *joinedMessages;

@end
