//
//  WPPostViewModel.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 09/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPPostViewModel.h"
#import "WPClient.h"
#import "WPGetPostRequest.h"
#import "WPPostOfSiteRoute.h"
#import "WPPost.h"
#import "WPUser.h"

#import "WPViewModel+Friend.h"

static NSString *const WPHTMLStringOfPostFormat = @"<html><head><style>*{max-width: 100%%};</style></head><body><h1>%@</h1><h5>%@</h5>%@<script>elements = document.getElementsByTagName('*')\nfor(i = 0;i < elements.length; i++) {\nelements[i].removeAttribute('height')\n}</script></body></html>";

@interface WPPostViewModel ()

@property (strong, nonatomic) WPPost *post;

@property (strong, nonatomic) NSNumber *siteID;
@property (strong, nonatomic) NSNumber *postID;

@property (copy, nonatomic) NSString *HTMLString;
@property (strong, nonatomic) NSURL *baseURL;
@property (assign, nonatomic) NSInteger numberOfComments;

@end

@implementation WPPostViewModel

- (instancetype)initWithSiteID:(NSNumber *)siteID postID:(NSNumber *)postID
{
    NSParameterAssert(siteID);
    NSParameterAssert(postID);
    
    self = [super init];
    if (self) {
        self.siteID = siteID;
        self.postID = postID;
        
        RAC(self, HTMLString) = [RACObserve(self, post)
            map:^id(WPPost *post) {
                NSString *HTMLString = nil;
                if (post) {
                    HTMLString = [NSString stringWithFormat:WPHTMLStringOfPostFormat, post.title, post.author.name, post.content];
                }
                return HTMLString;
            }];
        
        RAC(self, numberOfComments, @0) = RACObserve(self, post.numberOfComments);
        RAC(self, baseURL) = RACObserve(self, post.URL);
    }
    return self;
}

- (RACSignal *)reloadData
{
    return [[[RACSignal
        createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            WPPostOfSiteRoute *routeObject = [[WPPostOfSiteRoute alloc] init];
            routeObject.siteID = self.siteID;
            routeObject.postID = self.postID;
            
            WPGetPostRequest *request = [[WPGetPostRequest alloc] init];
            request.fields = @[ @"ID", @"site_ID", @"author", @"comment_count", @"content", @"URL", @"title" ];
            request.routeObject = routeObject;
            
            RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
            RACMulticastConnection *requestConnection = [[[WPClient sharedInstance] performRequest:request]
                publish];
            
            [disposable addDisposable:[[requestConnection.signal
                catchTo:[RACSignal empty]]
                setKeyPath:@keypath([WPPostViewModel new], post) onObject:self]];
            
            [disposable addDisposable:[requestConnection.signal subscribe:subscriber]];
            [disposable addDisposable:[requestConnection connect]];
            
            return disposable;
        }]
        ignoreValues]
        catch:^RACSignal *(NSError *error) {
            RACSignal *signal;
            if (self.closeSignal) {
                signal = [self.closeSignal
                    then:^RACSignal *{
                        return [RACSignal error:error];
                    }];
            } else {
                signal = [RACSignal error:error];
            }
            return signal;
        }];
}

@end
