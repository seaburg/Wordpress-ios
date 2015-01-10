//
//  WPPostViewModelTest.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 10/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#define EXP_SHORTHAND

#import <Foundation/Foundation.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostViewModel.h"
#import "WPClient.h"
#import "WPGetPostRequest.h"
#import "WPPostOfSiteRoute.h"
#import "WPPost.h"
#import "WPUser.h"

#import "WPViewModel+Friend.h"

SpecBegin(PostViewModel)

describe(@"PostViewModel", ^{
    NSNumber *const siteID = @1;
    NSNumber *const postID = @2;
    
    __block WPPostViewModel *viewModel;
    
    beforeEach(^{
        viewModel = [[WPPostViewModel alloc] initWithSiteID:siteID postID:postID];
    });
    
    describe(@"when it reloads a data", ^{
        
        context(@"when reloads a data is successful", ^{
    
            __block WPPost *post;
            __block id mockedClient;
            
            beforeEach(^{
                WPUser *author = [[WPUser alloc] init];
                author.userID = @1;
                author.name = @"Author name";
                
                post = [[WPPost alloc] init];
                post.title = @"title of the post";
                post.content = @"content of the post";
                post.numberOfComments = @42;
                post.URL = [NSURL URLWithString:@"http://foo.bar"];
                post.author = author;
                
                mockedClient = OCMClassMock([WPClient class]);
                OCMStub(ClassMethod([mockedClient sharedInstance])).andReturn(mockedClient);
                OCMStub([mockedClient performRequest:[OCMArg isKindOfClass:[WPGetPostRequest class]]]).andDo(^(NSInvocation *inv) {
                    [inv retainArguments];
                    
                    RACSignal *signal = [RACSignal return:post];
                    [inv setReturnValue:&signal];
                });
                
                waitUntil(^(DoneCallback done) {
                    [[viewModel reloadData]
                        subscribeCompleted:^{
                            done();
                        }];
                });
            });
            
            it(@"should perform the `WPGetPostRequest` request for loading a data", ^{
                OCMVerify([mockedClient performRequest:[OCMArg checkWithBlock:^BOOL(WPGetPostRequest *obj) {
                    if (![obj isKindOfClass:[WPGetPostRequest class]]) {
                        return NO;
                    }
                    
                    if (![obj.routeObject isKindOfClass:[WPPostOfSiteRoute class]]) {
                        return NO;
                    }
                    WPPostOfSiteRoute *route = (WPPostOfSiteRoute *)obj.routeObject;

                    return ([route.siteID isEqualToNumber:siteID] && [route.postID isEqualToNumber:postID]);
                }]]);
            });
            
            it(@"should contain 42 comments", ^{
                expect(viewModel.numberOfComments).to.equal([post.numberOfComments integerValue]);
            });
            
            it(@"should contain `HTMLString` with the title of the post", ^{
                expect(viewModel.HTMLString).to.contain(post.title);
            });
            
            it(@"should contain `HTMLString` with the content of the post", ^{
                expect(viewModel.HTMLString).to.contain(post.content);
            });
            
            it(@"should contain `HTMLString` with the author name of the post", ^{
                expect(viewModel.HTMLString).to.contain(post.author.name);
            });
            
            it(@"should contain `baseURL` with the url of the post", ^{
                expect(viewModel.baseURL).to.equal(post.URL);
            });
        });
        
        context(@"when reloads a data is failed", ^{
            
            __block id mockedCloseSignal;
            
            beforeEach(^{
                RACSubject *closeSignal = [RACReplaySubject replaySubjectWithCapacity:1];
                [closeSignal sendCompleted];
                
                mockedCloseSignal = OCMPartialMock(closeSignal);
                viewModel.closeSignal = mockedCloseSignal;
                
                id mockedClient = OCMClassMock([WPClient class]);
                OCMStub(ClassMethod([mockedClient sharedInstance])).andReturn(mockedClient);
                OCMStub([mockedClient performRequest:[OCMArg isKindOfClass:[WPGetPostRequest class]]]).andReturn([RACSignal error:[NSError new]]);
                
                waitUntil(^(DoneCallback done) {
                    [[viewModel reloadData]
                        subscribeError:^(NSError *error) {
                            done();
                        }];
                });
            });
            
            it(@"should close the screen", ^{
                OCMVerify([mockedCloseSignal subscribe:OCMOCK_ANY]);
            });
        });
    });
        
});

SpecEnd