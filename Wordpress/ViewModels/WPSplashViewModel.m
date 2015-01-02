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
    return [[[[[[RACSignal
        defer:^RACSignal *{
            WPGetSiteRequest *getSiteRequest = [[WPGetSiteRequest alloc] init];
            WPSite *currentSite = [WPClient sharedInstance].currentSite;
            getSiteRequest.routeObject = currentSite;
        
            return [[WPClient sharedInstance] performRequest:getSiteRequest];
        }]
        doNext:^(WPSite *site) {
            [WPClient sharedInstance].currentSite = site;
        }]
        doError:^(NSError *error) {
            @strongify(self);
            self.errorMessage = [error localizedDescription];
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
