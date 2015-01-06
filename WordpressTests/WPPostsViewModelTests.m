//
//  WPPostsViewModelTests.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 06/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#define EXP_SHORTHAND

#import <Foundation/Foundation.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostsViewModel.h"
#import "WPPaginator.h"
#import "WPPost.h"
#import "WPPostsItemViewModel.h"

SpecBegin(PostsViewModel)

describe(@"PostsViewModel", ^{
    __block WPPostsViewModel *viewModel;
    __block WPPaginator *mockedPaginator;
    
    __block BOOL nextPageExisted;
    __block NSArray *objects;
    
    beforeEach(^{
        nextPageExisted = YES;
        NSMutableArray *mutableObjects = [NSMutableArray array];
        {
            WPPost *post = [[WPPost alloc] init];
            post.postID = @1;
            post.title = @"title1";
            [mutableObjects addObject:post];
        }
        {
            WPPost *post = [[WPPost alloc] init];
            post.postID = @2;
            post.title = @"title2";
            [mutableObjects addObject:post];
        }
        {
            WPPost *post = [[WPPost alloc] init];
            post.postID = @3;
            post.title = @"title3";
            [mutableObjects addObject:post];
        }
        {
            WPPost *post = [[WPPost alloc] init];
            post.postID = @4;
            post.title = @"title4";
            [mutableObjects addObject:post];
        }
        objects = [mutableObjects copy];
        
        mockedPaginator = OCMPartialMock([[WPPaginator alloc] init]);
        OCMStub([mockedPaginator objects]).andDo(^(NSInvocation *inv) {
            [inv setReturnValue:&objects];
        });
        OCMStub([mockedPaginator nextPageExisted]).andDo(^(NSInvocation *inv) {
            [inv setReturnValue:&nextPageExisted];
        });
        viewModel = [[WPPostsViewModel alloc] initWithPaginator:mockedPaginator];
    });
    
    describe(@"when it initialized", ^{
        it(@"should indicate that the next page exists", ^{
            expect(viewModel.nextPageExisted).to.beTruthy();
        });
        
        it(@"should containt 10 objects", ^{
            expect(viewModel.numberOfObjets).to.equal(4);
        });
    });
    
    describe(@"when the page loads", ^{
        it(@"should send `reloadData` message to paginatro", ^{
            
            OCMExpect([mockedPaginator reloadData]).andReturn([RACSignal empty]);
            waitUntil(^(DoneCallback done) {
                [[viewModel reloadData]
                    subscribeCompleted:^{
                        OCMVerifyAll((id)mockedPaginator);
                        done();
                    }];
            });
        });
        
        it(@"should send `loadNextPage` message to paginatro", ^{
            
            OCMExpect([mockedPaginator loadNextPage]).andReturn([RACSignal empty]);
            waitUntil(^(DoneCallback done) {
                [[viewModel loadNextPage]
                    subscribeCompleted:^{
                        OCMVerifyAll((id)mockedPaginator);
                        done();
                    }];
            });
        });
    });
    
    describe(@"when get item with index", ^{
        it(@"should return item with `title3` title", ^{
            WPPostsItemViewModel *itemViewModel = [viewModel itemViewModelAtIndex:2];
            expect(itemViewModel.title).to.equal(@"title3");
        });
    });
    
    describe(@"when data changed", ^{
        
        it(@"should notify that the data has been updated", ^{
            waitUntil(^(DoneCallback done) {
                [[[viewModel dataUpdated]
                    take:1]
                    subscribeNext:^(id x) {
                        done();
                    }];
                [mockedPaginator willChangeValueForKey:@"objects"];
                [mockedPaginator didChangeValueForKey:@"objects"];
            });
        });
    });
});

SpecEnd
