//
//  WPRouter+Start.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 11/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPRouter+Start.h"
#import "WPPostsViewModelImp.h"
#import "WPPostsViewController.h"
#import "WPSite.h"


@implementation WPRouter (Start)

- (RACSignal *)presentStartScreenWithSite:(WPSite *)site
{
    NSParameterAssert(site);
    
    return [RACSignal
        defer:^RACSignal *{
            WPPostsViewModel *viewModel = [[WPPostsViewModel alloc] initWithSite:site];
            WPPostsViewController *viewController = [[WPPostsViewController alloc] initWithPostsViewModel:viewModel];
            
            return [self setRootViewController:viewController viewModel:viewModel];
        }];
}


@end
