//
//  AFURLSessionManager+RACExtension.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AFURLSessionManager+RACExtension.h"

@implementation AFURLSessionManager (RACExtension)

- (RACSignal *)rac_dataTaskWithRequest:(NSURLRequest *)request
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (!error) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted && task.state != NSURLSessionTaskStateCanceling) {
                [task cancel];
            }
        }];
    }];
}

@end
