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
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
        NSInteger pageSize = MAX([self.objects count], self.pageSize);
        RACMulticastConnection *requestConnection = [[[self performRequestWithPageSize:pageSize offset:0]
            map:^id(id<WPResponsePaginating> value) {
                return [value objects];
            }]
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
        
        RACMulticastConnection *requestConnection = [[[self performRequestWithPageSize:self.pageSize offset:[self.objects count]]
            map:^id(id<WPResponsePaginating> value) {
                return [value objects];
            }]
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
        WPRequest<WPRequestPaginating> *request = [self.request copy];
        [request setNumber:@(pageSize)];
        [request setOffset:@(offset)];
        
        RACMulticastConnection *requestConnection = [[self.sessionManager performRequest:request]
            publish];
        
        RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
        [disposable addDisposable:[[[requestConnection.signal
            map:^id(id<WPResponsePaginating> value) {
                return [value totalObjects];
            }]
            catchTo:[RACSignal empty]]
            setKeyPath:@keypath(self, totalObjects) onObject:self]];
        
        [disposable addDisposable:[requestConnection.signal subscribe:subscriber]];
        [disposable addDisposable:[requestConnection connect]];
        
        return disposable;
    }];
}

@end
