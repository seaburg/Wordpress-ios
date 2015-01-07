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
@property (assign, nonatomic) NSInteger maxSizeOfPage;
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
    return [self initWithRequest:request sessionManager:sessionManager pageSize:pageSize maxSizeOfPage:NSIntegerMax];
}

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager pageSize:(NSInteger)pageSize maxSizeOfPage:(NSInteger)maxSizeOfPage;
{
    NSParameterAssert(sessionManager);
    NSParameterAssert(request);
    NSAssert([[[request class] responseClass] conformsToProtocol:@protocol(WPResponsePaginating)], @"`responseClass` should conforms to `WPResponsePaginating` protocol");
    
    self = [super init];
    if (self) {
        self.request = request;
        self.sessionManager = sessionManager;
        self.pageSize = pageSize;
        self.maxSizeOfPage = maxSizeOfPage;
        
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
    doNext:^(NSArray *objects) {
        @strongify(self);
        self.objects = objects;
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
    doNext:^(NSArray *objects) {
        @strongify(self);
        NSMutableArray *mutableObjects = [NSMutableArray arrayWithArray:self.objects];
        [mutableObjects addObjectsFromArray:objects];
        self.objects = mutableObjects;
    }]
    ignoreValues];
}

#pragma mark - Private methods

- (RACSignal *)performRequestWithPageSize:(NSInteger)pageSize offset:(NSInteger)offset
{
    @weakify(self);
    return [[[RACSignal
        defer:^RACSignal *{
            NSInteger numberOfRequests = ceilf((CGFloat)pageSize / self.maxSizeOfPage);
        
            NSMutableArray *paramsOfRequests = [NSMutableArray array];
            for (NSInteger requestIndex = 0; requestIndex < numberOfRequests; ++requestIndex) {
                NSInteger requestOffset = offset + requestIndex * self.maxSizeOfPage;
                NSInteger requestPageSize = MIN(offset + pageSize - requestOffset, self.maxSizeOfPage);
                
                [paramsOfRequests addObject:RACTuplePack(@(requestOffset), @(requestPageSize))];
            }
        
            return [[[[paramsOfRequests.rac_sequence
                map:^id(RACTuple *value) {
                    RACTupleUnpack(NSNumber *offset, NSNumber *number) = value;
                    WPRequest<WPRequestPaginating> *request = [self.request copy];
                    [request setOffset:offset];
                    [request setNumber:number];
                    
                    return request;
                }]
                signalWithScheduler:[RACScheduler currentScheduler]]
                map:^RACStream *(WPRequest *request) {
                    return [self.sessionManager performRequest:request];
                }]
                concat];
        }]
        doNext:^(id<WPResponsePaginating> response) {
            @strongify(self);
            self.totalObjects = [[response totalObjects] integerValue];
        }]
        aggregateWithStart:[NSArray new] reduce:^id(NSArray *running, id<WPResponsePaginating> next) {
            return [running arrayByAddingObjectsFromArray:[next objects]];
        }];
}

@end
