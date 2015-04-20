//
//  UIWebView+Tuple.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 20/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIWebView+Tuple.h"

@implementation UIWebView (Tuple)

- (void)wp_loadWithHTMLStringAndBaseURLTuple:(RACTuple *)tuple
{
    RACTupleUnpack(NSString *HTMLString, NSURL *pageURL) = tuple;
    [self loadHTMLString:HTMLString baseURL:pageURL];
}

@end
