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

#import "WPViewModel+Friend.h"

@interface WPSplashViewModel ()

@property (copy, nonatomic) NSString *errorMessage;

@end

@implementation WPSplashViewModel

- (RACSignal *)fetchData
{
    @weakify(self);
    return [[[[[[[RACSignal
        defer:^RACSignal *{
            WPGetSiteRequest *getSiteRequest = [[WPGetSiteRequest alloc] init];
            WPSite *currentSite = [WPClient sharedInstance].currentSite;
            getSiteRequest.routeObject = currentSite;
            
            RACSignal *getSiteSignal = [[WPClient sharedInstance] performRequest:getSiteRequest];
            
            return getSiteSignal;
        }]
        doError:^(NSError *error) {
            @strongify(self);
            self.errorMessage = [error localizedDescription];
        }]
        doNext:^(WPSite *site) {
            [WPClient sharedInstance].currentSite = site;
        }]
        catch:^RACSignal *(NSError *error) {
            return [[[[RACSignal error:error]
                materialize]
                delay:0.3]
                dematerialize];
        }]
        retry]
        flattenMap:^RACStream *(WPSite *value) {
            @strongify(self);
            
            RACSignal *signal = nil;
            if (self.closeSignal) {
                signal = [self.closeSignal
                    then:^RACSignal *{
                        return [RACSignal return:value];
                    }];
            } else {
                signal = [RACSignal return:value];
            }
            
            return signal;
        }]
        flattenMap:^RACStream *(WPSite *site) {
            return [[WPRouter sharedInstance] presentPostsScreenWithSite:site];
        }];
}

@end
