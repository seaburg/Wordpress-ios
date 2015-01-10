//
//  WPRouter+Post.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPRouter+Post.h"
#import "WPPostViewModel.h"
#import "WPPostViewController.h"
#import "WPPost.h"

@implementation WPRouter (Post)

- (RACSignal *)presentPostScreenWithPost:(WPPost *)post
{
    return [RACSignal defer:^RACSignal *{
        
        WPPostViewModel *viewModel = [[WPPostViewModel alloc] initWithSiteID:post.siteID postID:post.postID];
        WPPostViewController *viewController = [[WPPostViewController alloc] initWithViewModel:viewModel];
        
        return [self pushViewController:viewController viewModel:viewModel animated:YES];
    }];
}

@end
