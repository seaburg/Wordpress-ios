//
//  WPSplashStateImp.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 18/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPSplashStateImp.h"

@interface WPSplashState ()

@property (copy, nonatomic) NSString *errorMessage;

@property (assign, nonatomic) BOOL loading;

@end

@implementation WPSplashState

+ (instancetype)emptyState
{
    WPSplashState *state = [[self alloc] init];

    return state;
}

- (instancetype)stateBySettingLoading:(BOOL)loading
{
    if (self.loading == loading) return self;

    WPSplashState *nextState = [self copy];
    nextState.loading = loading;

    return nextState;
}

- (instancetype)stateBySettingErrorMessage:(NSString *)errorMessage
{
    if ([self.errorMessage isEqualToString:errorMessage]) return self;

    WPSplashState *nextState = [self copy];
    nextState.errorMessage = errorMessage;

    return nextState;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    WPSplashState *copyObject = [[[self class] alloc] init];
    copyObject.errorMessage = self.errorMessage;
    copyObject.loading = self.loading;

    return copyObject;
}

@end
