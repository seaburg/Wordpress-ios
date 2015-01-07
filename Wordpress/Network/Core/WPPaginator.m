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

@property (assign, nonatomic) NSInteger logicalPageSize;
@property (assign, nonatomic) NSInteger maximumRealPageSize;
@property (assign, nonatomic) NSInteger totalObjects;

@property (strong, nonatomic) WPRequest<WPRequestPaginating> *request;
@property (strong, nonatomic) WPSessionManager *sessionManager;

@end

@implementation WPPaginator

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager
{
    return [self initWithRequest:request sessionManager:sessionManager logicalPageSize:25];
}

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager logicalPageSize:(NSInteger)logicalPageSize
{
    return [self initWithRequest:request sessionManager:sessionManager logicalPageSize:logicalPageSize maximumRealPageSize:NSIntegerMax];
}

- (instancetype)initWithRequest:(WPRequest<WPRequestPaginating> *)request sessionManager:(WPSessionManager *)sessionManager logicalPageSize:(NSInteger)logicalPageSize maximumRealPageSize:(NSInteger)maximumRealPageSize;
{
    NSParameterAssert(sessionManager);
    NSParameterAssert(request);
    NSAssert([[[request class] responseClass] conformsToProtocol:@protocol(WPResponsePaginating)], @"`responseClass` should conforms to `WPResponsePaginating` protocol");
    
    self = [super init];
    if (self) {
        self.request = request;
        self.sessionManager = sessionManager;
        self.logicalPageSize = logicalPageSize;
        self.maximumRealPageSize = maximumRealPageSize;
        
        RAC(self, nextPageExisted) = [[RACSignal combineLatest:@[ RACObserve(self, objects), RACObserve(self, totalObjects) ]]
            reduceEach:^id(NSArray *objects, NSNumber *totalObjects){
                return @([objects count] < [totalObjects integerValue]);
            }];
    }
    return self;
}

- (RACSignal *)reloadData
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
        NSInteger pageSize = MAX([self.objects count], self.logicalPageSize);
        RACMulticastConnection *requestConnection = [[self performRequestWithPageSize:pageSize offset:0]
            publish];
        
        RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
        
        [disposable addDisposable:[[requestConnection.signal
            catchTo:[RACSignal empty]]
            setKeyPath:@keypath(self, objects) onObject:self]];
        
        [disposable addDisposable:[requestConnection.signal subscribe:subscriber]];
        [disposable addDisposable:[requestConnection connect]];
        
        return disposable;
    }]
    ignoreValues];
}

- (RACSignal *)loadNextPage
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSCAssert(self.nextPageExisted, @"next page must exist");
        
        RACMulticastConnection *requestConnection = [[self performRequestWithPageSize:self.logicalPageSize offset:[self.objects count]]
            publish];
        
        RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
        [disposable addDisposable:[[[RACSignal combineLatest:@[ [RACSignal return:self.objects], requestConnection.signal]
            reduce:^id (NSArray *lArray, NSArray *rArray){
                NSMutableArray *objects = [NSMutableArray arrayWithArray:lArray];
                [objects addObjectsFromArray:rArray];
                
                return [objects copy];
            }]
            catchTo:[RACSignal empty]]
            setKeyPath:@keypath(self, objects) onObject:self]];
        
        [disposable addDisposable:[requestConnection.signal subscribe:subscriber]];
        [disposable addDisposable:[requestConnection connect]];
        
        return disposable;
    }]
    ignoreValues];
}

#pragma mark - Private methods

- (RACSignal *)performRequestWithPageSize:(NSInteger)pageSize offset:(NSInteger)offset
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSInteger numberOfRealPages = ceilf((CGFloat)pageSize / self.maximumRealPageSize);
        
        NSMutableArray *requests = [NSMutableArray array];
        for (NSInteger pageIndex = 0; pageIndex < numberOfRealPages; ++pageIndex) {
            
            NSInteger requestOffset = offset + pageIndex * self.maximumRealPageSize;
            NSInteger requestPageSize = MIN(offset + pageSize - requestOffset, self.maximumRealPageSize);
            
            WPRequest<WPRequestPaginating> *request = [self.request copy];
            [request setNumber:@(requestPageSize)];
            [request setOffset:@(requestOffset)];
            [requests addObject:request];
        }
        
        RACMulticastConnection *requestConnection = [[[[requests.rac_sequence
            signalWithScheduler:[RACScheduler currentScheduler]]
            map:^RACStream *(WPRequest *request) {
                return [self.sessionManager performRequest:request];
            }]
            concat]
            publish];
        
        RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
        [disposable addDisposable:[[[[requestConnection.signal
            takeLast:1]
            map:^id(id<WPResponsePaginating> value) {
                return [value totalObjects];
            }]
            catchTo:[RACSignal empty]]
            setKeyPath:@keypath(self, totalObjects) onObject:self]];
        
        [disposable addDisposable:[[requestConnection.signal
            aggregateWithStart:[NSArray new] reduce:^id(NSArray *running, id<WPResponsePaginating> next) {
                return [running arrayByAddingObjectsFromArray:[next objects]];
            }]
            subscribe:subscriber]];
        [disposable addDisposable:[requestConnection connect]];
        
        return disposable;
    }];
}

@end
