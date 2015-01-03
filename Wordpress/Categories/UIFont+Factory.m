//
//  UIFont+Factory.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 03/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "UIFont+Factory.h"

@implementation UIFont (Factory)

+ (instancetype)wp_regularFontWithSize:(CGFloat)size
{
    return [self systemFontOfSize:size];
}

+ (instancetype)wp_boldFontWithSize:(CGFloat)size
{
    return [self boldSystemFontOfSize:size];
}

@end
