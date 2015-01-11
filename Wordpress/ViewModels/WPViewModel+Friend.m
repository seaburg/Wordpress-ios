//
//  WPViewModel+Friend.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPViewModel+Friend.h"

@implementation WPViewModel (Friend)

@dynamic closeSignal;

- (RACSignal *)prepareForUse
{
    return [RACSignal empty];
}

@end
