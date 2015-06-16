//
//  WPRouter.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPViewModel;

@class RACSignal;
@class WPNavigationController;

@interface WPRouter : NSObject

- (instancetype)initWithWindow:(UIWindow *)window NS_DESIGNATED_INITIALIZER;

@end

@interface WPRouter (Protected)

// setRootViewController:viewModel: : -> RACSignal _
- (RACSignal *)setRootViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel;

// pushViewController:viewModel:animated: : -> RACSignal _
- (RACSignal *)pushViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel animated:(BOOL)animated;

// presentViewController:viewModel:animated: : -> RACSignal _
- (RACSignal *)presentViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel animated:(BOOL)animated;

@end
