//
//  WPPostsItemViewModelTests.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 03/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#define EXP_SHORTHAND

#import <Foundation/Foundation.h>
#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostsItemViewModel.h"
#import "WPPost.h"

#import "SDWebImageManager+RACExtension.h"

SpecBegin(PostsItemViewModel)

describe(@"PostsItemViewModel", ^{
    __block WPPostsItemViewModel *viewModel;
    __block WPPost *post;
    
    beforeEach(^{
        post = [[WPPost alloc] init];
        post.title = @"&lt;<b>title&#8217;</b><test>";
        post.excerpt = @"<b>excerpt&#x2019;</b><test>";
        post.numberOfComments = @25;
        post.featuredImageURL = [NSURL URLWithString:@"http://foo.bar"];
        viewModel = [[WPPostsItemViewModel alloc] initWithPost:post];
    });
    
    it(@"should contain title without html elements", ^{
        expect(viewModel.title).to.equal(@"<title’");
    });
    
    it(@"should contain excerpt without html element", ^{
        expect(viewModel.excerpt).to.equal(@"excerpt’");
    });
    
    it(@"should contain 25 comments", ^{
        expect(viewModel.numberOfComments).to.equal(@25);
    });
    
    context(@"when featured image exist", ^{
        __block id mockedWebImageManager;
        __block UIImage *image;
        beforeEach(^{
            image = [UIImage new];
            
            mockedWebImageManager = OCMClassMock([SDWebImageManager class]);
            OCMStub([mockedWebImageManager sharedManager]).andReturn(mockedWebImageManager);
            [[OCMStub([mockedWebImageManager rac_downloadImageWithURL:post.featuredImageURL options:0]) ignoringNonObjectArgs] andReturn:[RACSignal return:image]];
        });
        
        it(@"should return placeholder image while the image is loaded", ^{
            waitUntil(^(DoneCallback done) {
                [[[viewModel image]
                    take:1]
                    subscribeNext:^(id x) {
                        expect(x).to.equal([UIImage imageNamed:@"post_placeholder"]);
                        done();
                    }];
            });
        });
        
        it(@"should return downloaded image", ^{
            waitUntil(^(DoneCallback done) {
                [[[[viewModel image]
                    skip:1]
                    take:1]
                    subscribeNext:^(id x) {
                        expect(x).to.equal(image);
                        done();
                    }];
            });
        });
    });
    
    context(@"when featured image not exist", ^{
        
        beforeEach(^{
            post.featuredImageURL = nil;
        });
        
        it(@"should return placeholder image", ^{
            waitUntil(^(DoneCallback done) {
                [[[viewModel image]
                    take:1]
                    subscribeNext:^(id x) {
                        expect(x).to.equal([UIImage imageNamed:@"post_placeholder"]);
                        done();
                    }];
            });
        });
        
        it(@"should not return downloaded image", ^{
            waitUntil(^(DoneCallback done) {
                [[[[viewModel image]
                    skip:1]
                    timeout:0.2 onScheduler:[RACScheduler currentScheduler]]
                    subscribeError:^(NSError *error) {
                        done();
                    }];
            });
        });
    });
});

SpecEnd
