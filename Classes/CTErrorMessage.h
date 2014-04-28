//
//  CTErrorMessage.h
//
//  Created by Ryoichi Izumita on 2014/04/23.
//  Copyright (c) 2014 CAPH. All rights reserved.
//


#import "CTAbstractMessage.h"

@interface CTErrorMessage : CTAbstractMessage

@property (nonatomic, strong) NSError *error;

- (instancetype)initWithError:(NSError *)error
                     duration:(NSTimeInterval)duration
          canJoinOtherMessage:(BOOL)canJoinOtherMessage;

@end
