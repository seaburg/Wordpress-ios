//
//  WPSplashViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 18/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol WPSplashViewModel <NSObject>

// state : -> RACSignal WPSplashState
- (RACSignal *)state;

// fetchData : -> RACSignal _
- (RACSignal *)fetchData;

@end
