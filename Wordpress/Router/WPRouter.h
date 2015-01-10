//
//  WPRouter.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;
@class WPViewModel;
@class WPNavigationController;

@interface WPRouter : NSObject

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(WPRouter *)instance;

- (instancetype)initWithWindow:(UIWindow *)window;

@end

@interface WPRouter (Protected)

// setRootViewController:viewModel: : -> RACSignal _
- (RACSignal *)setRootViewController:(UIViewController *)viewController viewModel:(WPViewModel *)viewModel;

// pushViewController:viewModel:animated: : -> RACSignal _
- (RACSignal *)pushViewController:(UIViewController *)viewController viewModel:(WPViewModel *)viewModel animated:(BOOL)animated;

// presentViewController:viewModel:animated: : -> RACSignal _
- (RACSignal *)presentViewController:(UIViewController *)viewController viewModel:(WPViewModel *)viewModel animated:(BOOL)animated;

@end
