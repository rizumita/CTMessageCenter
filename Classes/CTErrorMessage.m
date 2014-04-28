//
//  CTErrorMessage.m
//
//  Created by Ryoichi Izumita on 2014/04/23.
//  Copyright (c) 2014 CAPH. All rights reserved.
//

#import "CTErrorMessage.h"

@implementation CTErrorMessage

- (instancetype)initWithError:(NSError *)error
                     duration:(NSTimeInterval)duration
          canJoinOtherMessage:(BOOL)canJoinOtherMessage
{
    self = [super initWithContent:error.localizedDescription subContent:nil duration:duration canJoinOtherMessage:canJoinOtherMessage];
    if (self) {
        _error = error;
    }
    return self;
}

@end
