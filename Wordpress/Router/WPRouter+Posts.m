//
//  WPRouter+Posts.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPRouter+Posts.h"
#import "WPPostsViewModel.h"
#import "WPPostsViewController.h"
#import "WPClient.h"
#import "WPPaginator.h"
#import "WPGetPostsRequest.h"
#import "WPSite.h"

@implementation WPRouter (Posts)

- (RACSignal *)presentPostsScreenWithSite:(WPSite *)site
{
    NSParameterAssert(site);
    
    return [RACSignal
        defer:^RACSignal *{
        
            WPGetPostsRequest *request = [[WPGetPostsRequest alloc] init];
            request.routeObject = site;
            request.fields = @[@"ID", @"site_ID", @"author", @"title", @"excerpt", @"comment_count", @"featured_image" ];
        
            WPPaginator *paginator = [[WPPaginator alloc] initWithRequest:request sessionManager:[WPClient sharedInstance] pageSize:25 maxSizeOfPage:100];
        
            WPPostsViewModel *viewModel = [[WPPostsViewModel alloc] initWithPaginator:paginator];
            WPPostsViewController *viewController = [[WPPostsViewController alloc] initWithPostsViewModel:viewModel];
        
            return [self pushViewController:viewController viewModel:viewModel animated:YES];
        }];
}

@end
