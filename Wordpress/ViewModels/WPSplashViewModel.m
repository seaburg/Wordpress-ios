//
//  WPSplashViewModel.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPSplashViewModel.h"
#import "WPRouter.h"
#import "WPClient.h"
#import "WPGetSiteRequest.h"
#import "WPSite.h"

@interface WPSplashViewModel ()

@property (copy, nonatomic) NSString *errorMessage;

@end

@implementation WPSplashViewModel

- (RACSignal *)fetchData
{
    @weakify(self);
    return [[[[RACSignal
        createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            WPGetSiteRequest *getSiteRequest = [[WPGetSiteRequest alloc] init];
            WPSite *currentSite = [WPClient sharedInstance].currentSite;
            getSiteRequest.routeObject = currentSite;
            
            RACMulticastConnection *getSiteConnection = [[[WPClient sharedInstance] performRequest:getSiteRequest]
                publish];
            
            RACCompoundDisposable *diposable = [RACCompoundDisposable compoundDisposable];
            
            [diposable addDisposable:[[getSiteConnection.signal
                catchTo:[RACSignal empty]]
                setKeyPath:@keypath([WPClient new], currentSite) onObject:[WPClient sharedInstance]]];
            
            [diposable addDisposable:[[[[getSiteConnection.signal
                materialize]
                filter:^BOOL(RACEvent *value) {
                    return (value.eventType == RACEventTypeError);
                }]
                map:^id(RACEvent *value) {
                    return [value.error localizedDescription];
                }]
                setKeyPath:@keypath(self, errorMessage) onObject:self]];
            
            [diposable addDisposable:[getSiteConnection.signal subscribe:subscriber]];
            [diposable addDisposable:[getSiteConnection connect]];
            
            return diposable;
        }]
        catch:^RACSignal *(NSError *error) {
            return [[[[RACSignal error:error]
                materialize]
                delay:0.3]
                dematerialize];
        }]
        retry]
        then:^RACSignal *{
            return [[WPRouter sharedInstance] presentStartScreen];
        }];
}

@end
