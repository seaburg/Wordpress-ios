//
//  WPRouter+Posts.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPRouter+Posts.h"
#import "WPPostsViewModelImp.h"
#import "WPPostsViewController.h"
#import "WPSite.h"

@implementation WPRouter (Posts)

- (RACSignal *)presentPostsScreenWithSite:(WPSite *)site
{
    NSParameterAssert(site);
    
    return [RACSignal
        defer:^RACSignal *{
            WPPostsViewModel *viewModel = [[WPPostsViewModel alloc] initWithSite:site];
            WPPostsViewController *viewController = [[WPPostsViewController alloc] initWithPostsViewModel:viewModel];
        
            return [self pushViewController:viewController viewModel:viewModel animated:YES];
        }];
}

@end
