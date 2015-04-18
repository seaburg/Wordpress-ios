//
//  WPStateMachineImp.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/02/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import "WPStateMachine.h"

@class RACSignal;

@interface WPStateMachine : NSObject <WPStateMachine>

- (instancetype)initWithStartState:(id)startState NS_DESIGNATED_INITIALIZER;

- (RACSignal *)pushTransition:(id(^)(id state))transition;

// pushTransition: RACSignal (State -> State) -> RACSignal _
- (RACSignal *)pushTransitionSignal:(RACSignal *)transitionSignal;

@end
