//
//  WPPaginatorTests.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 04/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#define EXP_SHORTHAND

#import <Foundation/Foundation.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPaginator.h"
#import "WPRequest.h"
#import "WPSessionManager.h"

@interface WPFakeResponse : NSObject<WPResponsePaginating>
@end

@implementation WPFakeResponse

-(NSArray *)objects
{
    return nil;
}

- (NSNumber *)totalObjects
{
    return nil;
}

@end

@interface WPFakeRequest : WPRequest<WPRequestPaginating>

@property (strong, nonatomic) NSNumber *offset;
@property (strong, nonatomic) NSNumber *number;

@end

@implementation WPFakeRequest

+ (Class)responseClass
{
    return [WPFakeResponse class];
}

@end

SpecBegin(Paginator)

describe(@"Paginator", ^{
    __block WPPaginator *paginator;
    __block WPFakeRequest *request;
    __block NSArray *fakeObjects;
    __block id mockedSessionManager;
    
    beforeEach(^{
        
        NSMutableArray *mutableObjects = [NSMutableArray array];
        for (NSInteger i = 0; i < 25; ++i) {
            [mutableObjects addObject:[[NSObject alloc] init]];
        }
        fakeObjects = [mutableObjects copy];

        mockedSessionManager = OCMClassMock([WPSessionManager class]);
        OCMStub(ClassMethod([mockedSessionManager sharedInstance])).andReturn(mockedSessionManager);
        request = [WPFakeRequest new];
        paginator = [[WPPaginator alloc] initWithRequest:request sessionManager:mockedSessionManager pageSize:3 maxSizeOfPage:6];
    });
    
    describe(@"when it initialized", ^{
        it(@"should set `nextPageExisted` to `NO`", ^{
            expect(paginator.nextPageExisted).to.beFalsy();
        });
        
        it(@"should not containt objects", ^{
            expect([paginator.objects count]).to.equal(0);
        });
    });
    
    describe(@"when it load data", ^{
    
        __block id<WPResponsePaginating> mockedResponse;
        
        beforeEach(^{
            
            mockedResponse = OCMProtocolMock(@protocol(WPResponsePaginating));
            OCMStub([mockedResponse conformsToProtocol:@protocol(WPResponsePaginating)]).andReturn(YES);
            OCMStub([mockedSessionManager performRequest:[OCMArg isKindOfClass:[WPFakeRequest class]]]).andDo(^(NSInvocation *inv) {
                [inv retainArguments];
                
                RACSignal *returnObejct = [RACSignal return:mockedResponse];
                [inv setReturnValue:&returnObejct];
            });
        });
        
        describe(@"when it load first page", ^{
            
            context(@"when exists only one page", ^{
                beforeEach(^{
                    OCMStub([mockedResponse objects]).andReturn([fakeObjects subarrayWithRange:NSMakeRange(0, 3)]);
                    OCMStub([mockedResponse totalObjects]).andReturn(@3);
                    
                    waitUntil(^(DoneCallback done) {
                        [[paginator reloadData]
                            subscribeCompleted:^{
                                done();
                            }];
                    });
                });
                
                it(@"should preform request with offset == 0 and page size == 3", ^{
                    OCMVerify([mockedSessionManager performRequest:[OCMArg checkWithBlock:^BOOL(WPFakeRequest *obj) {
                        if (![obj isKindOfClass:[WPFakeRequest class]]) {
                            return NO;
                        }
                        return ([obj.number isEqualToNumber:@3] && [obj.offset isEqualToNumber:@0]);
                    }]]);
                });
                
                it(@"should containt 3 objects", ^{
                    expect([paginator.objects count]).to.equal(3);
                });
                
                it(@"should set `nextPageExisted` to `NO`", ^{
                    expect(paginator.nextPageExisted).to.equal(NO);
                });
            });
            
            context(@"when exists more than one page", ^{
                beforeEach(^{
                    OCMStub([mockedResponse objects]).andReturn([fakeObjects subarrayWithRange:NSMakeRange(0, 3)]);
                    OCMStub([mockedResponse totalObjects]).andReturn(@6);
                    
                    waitUntil(^(DoneCallback done) {
                        [[paginator reloadData]
                         subscribeCompleted:^{
                             done();
                         }];
                    });
                });
                
                it(@"should set `nextPageExisted` to `YES`", ^{
                    expect(paginator.nextPageExisted).to.equal(YES);
                });
            });
        });
        
        describe(@"when it load next page", ^{
            
            beforeEach(^{
                OCMStub([mockedResponse objects]).andReturn([fakeObjects subarrayWithRange:NSMakeRange(0, 3)]);
                OCMStub([mockedResponse totalObjects]).andReturn(@6);
                
                waitUntil(^(DoneCallback done) {
                    [[[paginator reloadData]
                        then:^RACSignal *{
                            return [paginator loadNextPage];
                        }]
                        subscribeCompleted:^{
                            done();
                        }];
                });
            });
            
            it(@"should should preform request with offset == 3 and page size == 3", ^{
                OCMVerify([mockedSessionManager performRequest:[OCMArg checkWithBlock:^BOOL(WPFakeRequest *obj) {
                    if (![obj isKindOfClass:[WPFakeRequest class]]) {
                        return NO;
                    }
                    
                    return ([obj.offset isEqualToNumber:@3] && [obj.number isEqualToNumber:@3]);
                }]]);
            });
            
            it(@"should containt 6 objects", ^{
                expect([paginator.objects count]).to.equal(6);
            });
            
            it(@"should preform request with offset == 0 and page size == 6 when call reload data", ^{
                waitUntil(^(DoneCallback done) {
                    [[paginator reloadData]
                        subscribeCompleted:^{
                            OCMVerify([mockedSessionManager performRequest:[OCMArg checkWithBlock:^BOOL(WPFakeRequest *obj) {
                                if (![obj isKindOfClass:[WPFakeRequest class]]) {
                                    return NO;
                                }
                                
                                return ([obj.offset isEqualToNumber:@0] && [obj.number isEqualToNumber:@6]);
                            }]]);
                            done();
                        }];
                });
            });
        });
        
        describe(@"when required page size more than max real page size", ^{
            
            beforeEach(^{
                
                __block NSInteger numberOfResponseObjects = 3;
                OCMStub([mockedResponse objects]).andDo(^(NSInvocation *inv) {
                    NSArray *objects = [fakeObjects subarrayWithRange:NSMakeRange(0, numberOfResponseObjects)];
                    [inv setReturnValue:&objects];
                });
                OCMStub([mockedResponse totalObjects]).andReturn(@12);
                
                waitUntil(^(DoneCallback done) {
                    [[[[[[paginator reloadData]
                        then:^RACSignal *{
                            return [paginator loadNextPage];
                        }]
                        then:^RACSignal *{
                            return [paginator loadNextPage];
                        }]
                        then:^RACSignal *{
                            return [paginator loadNextPage];
                        }]
                        then:^RACSignal *{
                            numberOfResponseObjects = 6;
                            return [paginator reloadData];
                        }]
                        subscribeCompleted:^{
                            done();
                        }];
                });
            });
            
            it(@"should load in parts", ^{
                OCMVerify([mockedSessionManager performRequest:[OCMArg checkWithBlock:^BOOL(WPFakeRequest *obj) {
                    if (![obj isKindOfClass:[WPFakeRequest class]]) {
                        return NO;
                    }
                    
                    if ([obj.offset isEqualToNumber:@0] && [obj.number isEqualToNumber:@6]) {
                        return YES;
                    }
                    return NO;
                }]]);
                
                OCMVerify([mockedSessionManager performRequest:[OCMArg checkWithBlock:^BOOL(WPFakeRequest *obj) {
                    if (![obj isKindOfClass:[WPFakeRequest class]]) {
                        return NO;
                    }
                    if ([obj.offset isEqualToNumber:@6] && [obj.number isEqualToNumber:@6]) {
                        return YES;
                    }
                    return NO;
                }]]);
            });
            
            it(@"should containt 12 objects after loading", ^{
                expect([paginator.objects count]).to.equal(12);
            });
        });
    });
});

SpecEnd
