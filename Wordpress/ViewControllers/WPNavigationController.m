//
//  WPNavigationController.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 30/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPNavigationController.h"

@interface WPNavigationController () <UINavigationControllerDelegate>

@property (weak, nonatomic) id<UINavigationControllerDelegate> originDelegate;

@end

@implementation WPNavigationController

- (void)commonInit
{
    self.originDelegate = self.delegate;
    [super setDelegate:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [super init];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    self.originDelegate = self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL respondsToSelector = [super respondsToSelector:aSelector];
    if (!respondsToSelector && self.originDelegate != self) {
        respondsToSelector = [self.originDelegate respondsToSelector:aSelector];
    }
    return respondsToSelector;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.originDelegate;
}

- (RACSignal *)rac_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @weakify(self);
    return [RACSignal defer:^RACSignal *{
        @strongify(self);

        RACSignal *didShowSignal = [[[[self rac_signalForSelector:@selector(navigationController:didShowViewController:animated:) fromProtocol:@protocol(UINavigationControllerDelegate)]
            take:1]
            ignoreValues]
            replay];
        
        [self pushViewController:viewController animated:animated];
        
        return didShowSignal;
    }];
}

- (RACSignal *)rac_popToRootViewControllerAnimated:(BOOL)animated
{
    @weakify(self);
    return [RACSignal defer:^RACSignal *{
        @strongify(self);
        
        RACSignal *didShowSignal = [[[[self rac_signalForSelector:@selector(navigationController:didShowViewController:animated:) fromProtocol:@protocol(UINavigationControllerDelegate)]
            take:1]
            ignoreValues]
            replay];
        
        NSArray *viewControllers = [self popToRootViewControllerAnimated:animated];
        
        return [[RACSignal return:viewControllers]
            concat:didShowSignal];
    }];
}

- (RACSignal *)rac_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @weakify(self);
    return [RACSignal defer:^RACSignal *{
        @strongify(self);
        
        RACSignal *didShowSignal = [[[[self rac_signalForSelector:@selector(navigationController:didShowViewController:animated:) fromProtocol:@protocol(UINavigationControllerDelegate)]
            take:1]
            ignoreValues]
            replay];
        
        NSArray *viewControllers = [self popToViewController:viewController animated:animated];
        
        return [[RACSignal return:viewControllers]
            concat:didShowSignal];
    }];
}

- (RACSignal *)rac_popViewControllerAnimated:(BOOL)animated
{
    @weakify(self);
    return [RACSignal defer:^RACSignal *{
        @strongify(self);
        
        RACSignal *didShowSignal = [[[[self rac_signalForSelector:@selector(navigationController:didShowViewController:animated:) fromProtocol:@protocol(UINavigationControllerDelegate)]
            take:1]
            ignoreValues]
            replay];
        
        UIViewController *viewController = [self popViewControllerAnimated:animated];
        
        return [[RACSignal return:viewController]
            concat:didShowSignal];
    }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.originDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)] && self.originDelegate != self) {
        [self.originDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

@end
