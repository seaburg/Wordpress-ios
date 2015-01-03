//
//  UIFont+Factory.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 03/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Factory)

+ (instancetype)wp_regularFontWithSize:(CGFloat)size;

+ (instancetype)wp_boldFontWithSize:(CGFloat)size;

@end
