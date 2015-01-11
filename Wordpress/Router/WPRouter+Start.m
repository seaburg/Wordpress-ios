//
//  WPRouter+Start.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 11/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPRouter+Start.h"
#import "WPPostsViewModel.h"
#import "WPPostsViewController.h"
#import "WPClient.h"
#import "WPPaginator.h"
#import "WPGetPostsRequest.h"
#import "WPSite.h"


@implementation WPRouter (Start)

- (RACSignal *)presentStartScreenWithSite:(WPSite *)site
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
            
            return [self setRootViewController:viewController viewModel:viewModel];
        }];
}


@end
