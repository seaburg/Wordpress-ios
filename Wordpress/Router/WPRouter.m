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
#import "WPViewModel.h"

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

#pragma mark - Private methods

- (RACSignal *)setRootViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel navigationController:(WPNavigationController *)navigationController
{
    return [[RACSignal
        defer:^RACSignal *{
            return [self prepareViewModel:viewModel];
        }]
        then:^RACSignal *{
            if ([viewModel respondsToSelector:@selector(setCloseSignal:)]) {
                @weakify(navigationController, viewController);

                RACSignal *closeSignal = [RACSignal
                    defer:^RACSignal *{
                        @strongify(navigationController, viewController);
                        NSCAssert([navigationController.viewControllers firstObject] == viewController, @"the root view controller should be `viewController`");

                        return [navigationController rac_setViewControllers:@[] animated:NO];
                    }];
                [viewModel setCloseSignal:closeSignal];
            }
            return [navigationController rac_setViewControllers:@[ viewController ] animated:NO];
        }];
}

- (RACSignal *)pushViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel navigationController:(WPNavigationController *)navigationController animated:(BOOL)animated
{
    return [[RACSignal
        defer:^RACSignal *{
            return [self prepareViewModel:viewModel];
        }]
        then:^RACSignal *{
            if ([navigationController.viewControllers count] == 0) {
                return [self setRootViewController:viewController viewModel:viewModel navigationController:navigationController];
            }

            if ([viewModel respondsToSelector:@selector(setCloseSignal:)]) {
                @weakify(navigationController, viewController);

                RACSignal *closeSignal = [RACSignal defer:^RACSignal *{
                    @strongify(navigationController, viewController);
                    NSCAssert([navigationController.viewControllers lastObject] == viewController, @"last object of `viewControllers` should be `viewController`");

                    return [navigationController rac_popViewControllerAnimated:YES];
                }];
                [viewModel setCloseSignal:closeSignal];
            }
            
            return [navigationController rac_pushViewController:viewController animated:animated];
        }];
}

- (RACSignal *)prepareViewModel:(id<WPViewModel>)viewModel
{
    return [RACSignal defer:^RACSignal *{
        if ([viewModel respondsToSelector:@selector(setRouter:)]) {
            [viewModel setRouter:self];
        }

        RACSignal *signal;
        if ([viewModel respondsToSelector:@selector(prepareForUse)]) {
            signal = [viewModel prepareForUse];
        } else {
            signal = [RACSignal empty];
        }
        return signal;
    }];
}

@end

#pragma mark - Protected methods

@implementation WPRouter (Protected)

- (RACSignal *)setRootViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel
{
    NSParameterAssert(viewController);
    NSParameterAssert(viewModel);
    
    return [RACSignal
        defer:^RACSignal *{
            return [self setRootViewController:viewController viewModel:viewModel navigationController:self.rootNavigationController];
        }];
}

- (RACSignal *)pushViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel animated:(BOOL)animated
{
    NSParameterAssert(viewController);
    NSParameterAssert(viewModel);
    
    return [RACSignal
        defer:^RACSignal *{
            return [self pushViewController:viewController viewModel:viewModel navigationController:self.rootNavigationController animated:animated];
        }];
}

- (RACSignal *)presentViewController:(UIViewController *)viewController viewModel:(id<WPViewModel>)viewModel animated:(BOOL)animated
{
    NSParameterAssert(viewController);
    NSParameterAssert(viewModel);
    
    return [[RACSignal
        defer:^RACSignal *{
            return [self prepareViewModel:viewModel];
        }]
        then:^RACSignal *{
            if ([viewModel respondsToSelector:@selector(setCloseSignal:)]) {
                RACSignal *closeSignal = [viewController rac_dismissViewControllerAnimated:YES];
                [viewModel setCloseSignal:closeSignal];
            }
            return [self.rootNavigationController rac_presentViewController:viewController animated:animated];
        }];
}

@end
