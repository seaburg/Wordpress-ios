//
//  UIViewController+RACExtension.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;
@interface UIViewController (RACExtension)

// rac_presentViewController:animated: : -> RACSignal _
- (RACSignal *)rac_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag;

// rac_dismissViewControllerAnimated: : -> RACSignal _
- (RACSignal *)rac_dismissViewControllerAnimated:(BOOL)flag;

@end
