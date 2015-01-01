//
//  WPSplashViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPViewModel.h"

@class RACSignal;
@class WPSite;

@interface WPSplashViewModel : WPViewModel

@property (copy, nonatomic, readonly) NSString *errorMessage;

// fetchData : -> RACSignal _
- (RACSignal *)fetchData;

@end
