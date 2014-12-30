//
//  WPNavigationController.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 30/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;
@interface WPNavigationController : UINavigationController

// rac_pushViewController:animated: : -> RACSignal _
- (RACSignal *)rac_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

// rac_popToRootViewControllerAnimated: : -> RACSignal NSArray
- (RACSignal *)rac_popToRootViewControllerAnimated:(BOOL)animated;

// rac_popToViewController:animated: : -> RACSignal NSArray
- (RACSignal *)rac_popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

// rac_popViewControllerAnimated: : -> RACSignal UIViewController
- (RACSignal *)rac_popViewControllerAnimated:(BOOL)animated;

@end
