//
//  WPPaginator.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPaginator.h"
#import "WPSessionManager.h"
#import "WPRequest.h"

@interface WPPaginator ()

@property (copy, nonatomic) NSArray *objects;
@property (assign, nonatomic) BOOL nextPageExisted;

@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger totalObjects;

@property (strong, nonatomic) WPRequest<WPRequestPaginating> *request;
@property (strong, nonatomic) WPSessionManager *sessionManager;

@end

@implementation WPPaginator

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager
{
    return [self initWithRequest:request sessionManager:sessionManager pageSize:25];
}

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager pageSize:(NSInteger)pageSize
{
    NSParameterAssert(sessionManager);
    NSParameterAssert(request);
    NSAssert([[[request class] responseClass] conformsToProtocol:@protocol(WPResponsePaginating)], @"`responseClass` should conforms to `WPResponsePaginating` protocol");
    
    self = [super init];
    if (self) {
        self.request = request;
        self.sessionManager = sessionManager;
        self.pageSize = pageSize;
        
        RAC(self, nextPageExisted) = [[RACSignal combineLatest:@[ RACObserve(self, objects), RACObserve(self, totalObjects) ]]
            reduceEach:^id(NSArray *objects, NSNumber *totalObjects){
                return @([objects count] < [totalObjects integerValue]);
            }];
    }
    return self;
}

- (RACSignal *)reloadData
{
    @weakify(self);
    return [[[RACSignal defer:^RACSignal *{
        
        NSInteger pageSize = MAX([self.objects count], self.pageSize);
        return [self performRequestWithPageSize:pageSize offset:0];
    }]
    doNext:^(id<WPResponsePaginating> x) {
        @strongify(self);
        
        self.objects = [x objects];
    }]
    ignoreValues];
}

- (RACSignal *)loadNextPage
{
    @weakify(self);
    return [[[RACSignal defer:^RACSignal *{
        NSCAssert(self.nextPageExisted, @"next page must exist");
        
        return [self performRequestWithPageSize:self.pageSize offset:[self.objects count]];
    }]
    doNext:^(id<WPResponsePaginating> x) {
        @strongify(self);
        
        NSMutableArray *objects = [NSMutableArray arrayWithArray:self.objects];
        [objects addObjectsFromArray:[x objects]];
        self.objects = objects;
    }]
    ignoreValues];
}

#pragma mark - Private methods

- (RACSignal *)performRequestWithPageSize:(NSInteger)pageSize offset:(NSInteger)offset
{
    @weakify(self);
    return [[RACSignal defer:^RACSignal *{
        WPRequest<WPRequestPaginating> *request = [self.request copy];
        [request setNumber:@(pageSize)];
        [request setOffset:@(offset)];
        
        return [self.sessionManager performRequest:request];
    }]
    doNext:^(id<WPResponsePaginating> x) {
        @strongify(self);
        self.totalObjects = [[x totalObjects] integerValue];
    }];
}

@end
