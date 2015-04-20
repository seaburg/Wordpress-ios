//
//  UIWebView+Tuple.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 20/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACTuple;

@interface UIWebView (Tuple)

- (void)wp_loadWithHTMLStringAndBaseURLTuple:(RACTuple *)tuple;

@end
