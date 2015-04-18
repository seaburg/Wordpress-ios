//
//  WPSplashStateImp.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 18/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPSplashState.h"

@protocol WPSplashState;

@interface WPSplashState : NSObject <WPSplashState, NSCopying>

+ (instancetype)emptyState;

- (instancetype)stateBySettingLoading:(BOOL)loading;

- (instancetype)stateBySettingErrorMessage:(NSString *)errorMessage;

@end
