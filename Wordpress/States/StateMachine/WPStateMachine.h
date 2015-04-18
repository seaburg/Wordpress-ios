//
//  WPStateMachine.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/02/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol WPStateMachine <NSObject>

// stateChanged : RACSignal a
@property (strong, nonatomic, readonly) RACSignal *stateChanged;

// transitionError : RACSignal NSError
@property (strong, nonatomic, readonly) RACSignal *transitionError;

@end
