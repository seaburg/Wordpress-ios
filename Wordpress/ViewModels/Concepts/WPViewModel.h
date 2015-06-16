//
//  WPViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 16/06/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPRouter;
@class RACSignal;

@protocol WPViewModel <NSObject>

@optional
- (void)setRouter:(WPRouter *)router;

// setCloseSignal: : RACSignal _ -> ()
- (void)setCloseSignal:(RACSignal *)closeSignal;

// prepareForUse : -> RACSignal _
- (RACSignal *)prepareForUse;

@end
