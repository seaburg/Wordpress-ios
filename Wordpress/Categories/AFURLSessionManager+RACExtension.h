//
//  AFURLSessionManager+RACExtension.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "AFURLSessionManager.h"

@class RACSignal;
@interface AFURLSessionManager (RACExtension)

// rac_dataTaskWithRequest: : -> RACSignal a
- (RACSignal *)rac_dataTaskWithRequest:(NSURLRequest *)request;

@end
