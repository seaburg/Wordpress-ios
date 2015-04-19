//
//  UIScrollView+RACCommand.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 02.09.14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <objc/runtime.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <libextobjc/extobjc.h>

#import "UIScrollView+RACCommand.h"

#pragma mark - PullToRefresh

static void* RACPullToRefreshCommandKey = &RACPullToRefreshCommandKey;
static void* RACPullToRefreshDisponseKey = &RACPullToRefreshDisponseKey;

@implementation UIScrollView (RACCommand_PullToRefresh)

- (RACCommand *)rac_pullToRefreshCommand
{
    return objc_getAssociatedObject(self, RACPullToRefreshCommandKey);
}

- (void)setRac_pullToRefreshCommand:(RACCommand *)rac_pullToRefreshCommand
{
    [objc_getAssociatedObject(self, RACPullToRefreshDisponseKey) dispose];
    objc_setAssociatedObject(self, RACPullToRefreshCommandKey, rac_pullToRefreshCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    @weakify(self);
    [self addPullToRefreshWithActionHandler:^{
        @strongify(self);

        [self.rac_pullToRefreshCommand execute:self.rac_pullToRefreshCommand];
    }];

    RACDisposable *enableDisponsable = [[[rac_pullToRefreshCommand.enabled combineLatestWith:rac_pullToRefreshCommand.executing]
        reduceEach:^id (NSNumber *enabled, NSNumber *executing){
            return @([enabled boolValue] || [executing boolValue]);
        }]
        setKeyPath:@keypath(self.showsPullToRefresh) onObject:self];

    RACDisposable *executingDisponsable = [rac_pullToRefreshCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.pullToRefreshView startAnimating];
        } else {
            [self.pullToRefreshView stopAnimating];
        }
    }];

    RACDisposable *disponsable = [RACDisposable disposableWithBlock:^{
        [enableDisponsable dispose];
        [executingDisponsable dispose];
    }];
    objc_setAssociatedObject(self, RACPullToRefreshDisponseKey, disponsable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - InfinityScroll

static void* RACInfinityScrollCommandKey = &RACInfinityScrollCommandKey;
static void* RACInfinityScrollDisponseKey = &RACInfinityScrollDisponseKey;

@implementation UIScrollView (RACCommand_InfinityScroll)

- (RACCommand *)rac_infinityScrollCommand
{
    return objc_getAssociatedObject(self, RACInfinityScrollCommandKey);
}

- (void)setRac_infinityScrollCommand:(RACCommand *)rac_infinityScrollCommand
{
    [objc_getAssociatedObject(self, RACInfinityScrollDisponseKey) dispose];
    objc_setAssociatedObject(self, RACInfinityScrollCommandKey, rac_infinityScrollCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    @weakify(self);
    [self addInfiniteScrollingWithActionHandler:^{
        @strongify(self);

        [self.rac_infinityScrollCommand execute:self.rac_infinityScrollCommand];
    }];

    RACDisposable *enableDisponsable = [[[rac_infinityScrollCommand.enabled combineLatestWith:rac_infinityScrollCommand.executing]
        reduceEach:^id (NSNumber *enabled, NSNumber *executing){
            return @([enabled boolValue] || [executing boolValue]);
        }]
        setKeyPath:@keypath(self.showsInfiniteScrolling) onObject:self];

    RACDisposable *executingDisponsable = [rac_infinityScrollCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.infiniteScrollingView startAnimating];
        } else {
            [self.infiniteScrollingView stopAnimating];
        }
    }];

    RACDisposable *disponsable = [RACDisposable disposableWithBlock:^{
        [enableDisponsable dispose];
        [executingDisponsable dispose];
    }];
    objc_setAssociatedObject(self, RACInfinityScrollDisponseKey, disponsable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end