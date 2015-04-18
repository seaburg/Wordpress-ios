//
//  UIActivityIndicatorView+Animated.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 18/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "UIActivityIndicatorView+Animated.h"

@implementation UIActivityIndicatorView (Animated)

- (void)setAnimated:(BOOL)animated
{
    if (animated) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

- (BOOL)animated
{
    return self.isAnimating;
}

@end
