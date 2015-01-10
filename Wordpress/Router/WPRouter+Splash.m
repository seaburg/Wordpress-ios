//
//  WPRouter+Splash.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPRouter+Splash.h"
#import "WPSplashViewModel.h"
#import "WPSplashViewController.h"

@implementation WPRouter (Splash)

- (RACSignal *)presentSplashScreen
{
    return [RACSignal
        defer:^RACSignal *{
            WPSplashViewModel *viewModel = [WPSplashViewModel new];
            WPSplashViewController *viewController = [[WPSplashViewController alloc] initWithViewModel:viewModel];
        
            return [self setRootViewController:viewController viewModel:viewModel];
        }];
}

@end
