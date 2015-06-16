//
//  WPSplashViewModel.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPSplashViewModelImp.h"
#import "WPStateMachineImp.h"
#import "WPSplashStateImp.h"
#import "WPClient.h"
#import "WPGetSiteRequest.h"
#import "WPSite.h"

#import "WPRouter+Start.h"
#import "RACSignal+Extension.h"

@interface WPSplashViewModel ()

@property (strong, nonatomic) WPStateMachine *stateMachine;

@property (weak, nonatomic) WPRouter *router;

@end

@implementation WPSplashViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stateMachine = [[WPStateMachine alloc] initWithStartState:[WPSplashState emptyState]];
    }
    return self;
}

- (RACSignal *)state
{
    return self.stateMachine.stateChanged;
}

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
        flattenMap:^RACStream *(WPSite *site) {
            return [self.router presentStartScreenWithSite:site];
        }]
        initially:^{
            @strongify(self);
            [[self.stateMachine
                pushTransition:^id(WPSplashState *state) {
                    return [state stateBySettingLoading:YES];
                }]
                subscribeCompleted:^{}];
        }]
        finally:^{
            @strongify(self);
            [[self.stateMachine
                pushTransition:^id(WPSplashState *state) {
                    return [state stateBySettingLoading:NO];
                }]
                subscribeCompleted:^{}];
        }]
        wp_retryAfterSignal:^RACSignal *(NSError *error) {
            @strongify(self);

            return [[self.stateMachine
                pushTransition:^id(id state) {
                    return [state stateBySettingErrorMessage:[error localizedDescription]];
                }]
                delay:2];
        }];
}

@end
