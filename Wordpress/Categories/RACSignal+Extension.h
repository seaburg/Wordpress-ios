//
//  RACSignal+Extension.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 13.02.15.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (Extension)

- (RACSignal *)wp_retryAfterSignal:(RACSignal *(^)(NSError *error))block;

@end
