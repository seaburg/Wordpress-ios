//
//  WPRouter.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPRouter.h"
#import "WPNavigationController.h"
#import "WPPaginator.h"
#import "WPClient.h"
#import "WPGetPostsRequest.h"
#import "WPSite.h"

#import "WPSplashViewController.h"
#import "WPPostsViewController.h"

#import "WPSplashViewModel.h"
#import "WPPostsViewModel.h"

#import "WPViewModel+Friend.h"
#import "UIViewController+RACExtension.h"

static WPRouter *_sharedInstance;

@interface WPRouter ()

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WPNavigationController *rootNavigationController;

@end

@implementation WPRouter

+ (instancetype)sharedInstance
{
    return _sharedInstance;
}

+ (void)setSharedInstance:(WPRouter *)instance
{
    _sharedInstance = instance;
}

- (instancetype)initWithWindow:(UIWindow *)window
{
    NSParameterAssert(window);
    
    self = [super init];
    if (self) {
        self.window = window;
        self.rootNavigationController = [WPNavigationController new];
        self.window.rootViewController = self.rootNavigationController;
    }
    
    return self;
}

- (RACSignal *)presentRootScreen
{
    @weakify(self);
    return [RACSignal defer:^RACSignal *{
        @strongify(self);
        
        WPSplashViewModel *viewModel = [WPSplashViewModel new];
        WPSplashViewController *viewController = [[WPSplashViewController alloc] initWithViewModel:viewModel];
        
        return [self setRootViewController:viewController viewModel:viewModel navigationController:self.rootNavigationController];
    }];
}

- (RACSignal *)presentStartScreen
{
    return [RACSignal defer:^RACSignal *{
        
        WPGetPostsRequest *request = [[WPGetPostsRequest alloc] init];
        request.routeObject = [WPClient sharedInstance].currentSite;
        WPPaginator *paginator = [[WPPaginator alloc] initWithRequest:request sessionManager:[WPClient sharedInstance]];
        
        WPPostsViewModel *viewModel = [[WPPostsViewModel alloc] initWithPaginator:paginator];
        WPPostsViewController *viewController = [[WPPostsViewController alloc] initWithPostsViewModel:viewModel];
        
        return [self setRootViewController:viewController viewModel:viewModel navigationController:self.rootNavigationController];
    }];
}

#pragma mark - Presentation

- (RACSignal *)setRootViewController:(UIViewController *)viewController viewModel:(WPViewModel *)viewModel navigationController:(WPNavigationController *)navigationController
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [navigationController setViewControllers:@[ viewController ] animated:NO];
        [subscriber sendCompleted];
        
        return nil;
    }];
}

- (RACSignal *)pushViewController:(UIViewController *)viewController viewModel:(WPViewModel *)viewModel navigationController:(WPNavigationController *)navigationController animated:(BOOL)animated
{
    @weakify(self);
    return [RACSignal defer:^RACSignal *{
        @strongify(self);
        
        if ([navigationController.viewControllers count] == 0) {
            return [self setRootViewController:viewController viewModel:viewModel navigationController:navigationController];
        }
        
        @weakify(navigationController);
        viewModel.closeSignal = [RACSignal defer:^RACSignal *{
            @strongify(navigationController);
            NSCAssert([navigationController.viewControllers lastObject] == viewController, @"last object of `viewControllers` should be `viewController`");
            
            return [navigationController rac_popViewControllerAnimated:YES];
        }];
        
        return [navigationController rac_pushViewController:viewController animated:animated];
    }];
}

- (RACSignal *)presentViewController:(UIViewController *)viewController viewModel:(WPViewModel *)viewModel animated:(BOOL)animated
{
    @weakify(self);
    return [RACSignal defer:^RACSignal *{
        @strongify(self);
        
        viewModel.closeSignal = [viewController rac_dismissViewControllerAnimated:YES];
        return [self.rootNavigationController rac_presentViewController:viewController animated:YES];
    }];
}

@end
