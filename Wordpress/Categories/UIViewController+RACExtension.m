//
//  UIViewController+RACExtension.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIViewController+RACExtension.h"

@implementation UIViewController (RACExtension)

- (RACSignal *)rac_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        [self presentViewController:viewControllerToPresent animated:flag completion:^{
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal *)rac_dismissViewControllerAnimated:(BOOL)flag
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        [self dismissViewControllerAnimated:flag completion:^{
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

@end
