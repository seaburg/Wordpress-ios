//
//  RACSignal+Extension.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 13.02.15.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "RACSignal+Extension.h"

@implementation RACSignal (Extension)

- (RACSignal *)wp_retryAfterSignal:(RACSignal *(^)(NSError *error))block
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];

        RACSchedulerRecursiveBlock recursiveBlock = ^(void(^reschedule)(void)) {
            RACDisposable *selfDisposable = [self subscribeNext:^(id x) {
                [subscriber sendNext:x];
            } error:^(NSError *error) {
                [disposable removeDisposable:selfDisposable];

                RACSignal *failSignal = block(error);
                NSCAssert(failSignal, @"fail signal can't be equal to `nil`");
                RACDisposable *failDisposable = [failSignal subscribeError:^(NSError *error) {
                    [subscriber sendError:error];
                } completed:^{
                    [disposable removeDisposable:failDisposable];
                    reschedule();
                }];
                [disposable addDisposable:failDisposable];
            } completed:^{
                [subscriber sendCompleted];
            }];
            [disposable addDisposable:selfDisposable];
        };

        RACDisposable *schedulerDisposable = [[RACScheduler currentScheduler] scheduleRecursiveBlock:recursiveBlock];
        [disposable addDisposable:schedulerDisposable];

        return disposable;
    }];
}

@end
