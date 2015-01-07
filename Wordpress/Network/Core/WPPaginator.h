//
//  WPPaginator.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPaginating.h"

@class WPSessionManager;
@class WPRequest;
@class RACSignal;

@interface WPPaginator : NSObject

@property (copy, nonatomic, readonly) NSArray *objects;

@property (assign, nonatomic, readonly) BOOL nextPageExisted;

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager;

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager pageSize:(NSInteger)pageSize;

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager pageSize:(NSInteger)pageSize maxSizeOfPage:(NSInteger)maxSizeOfPage;

// reloadData : -> RACSignal _
- (RACSignal *)reloadData;

// loadNextPage : -> RACSignal _
- (RACSignal *)loadNextPage;

@end
