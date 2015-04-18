//
//  WPStateMachineImp.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/02/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPStateMachineImp.h"

@interface WPStateMachine ()

@property (strong, nonatomic) RACSignal *stateChanged;

@property (strong, nonatomic) RACSubject *transitionError;

@property (strong, nonatomic) RACSubject *changeStateSubject;

@end

@implementation WPStateMachine

- (instancetype)initWithStartState:(id)startState
{
    self = [super init];
    if (self) {
        self.changeStateSubject = [RACSubject subject];
        self.transitionError = [RACSubject subject];

        @weakify(self);
        self.stateChanged = [[[[[self.changeStateSubject
            takeUntil:self.rac_willDeallocSignal]
            flattenMap:^RACStream *(RACSignal *value) {
                return [value
                    catch:^RACSignal *(NSError *error) {
                        @strongify(self);
                        [self.transitionError sendNext:error];

                        return [RACSignal empty];
                    }];
            }]
            scanWithStart:startState reduce:^id(id currentState, id(^transition)(id state)) {
                return transition(currentState);
            }]
            startWith:startState]
            replayLast];
    }
    return self;
}

- (RACSignal *)pushTransition:(id (^)(id))transition
{
    return [self pushTransitionSignal:[RACSignal return:transition]];
}

- (RACSignal *)pushTransitionSignal:(RACSignal *)transition
{
    return [[RACSignal
        createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            RACMulticastConnection *transitionConnection = [transition
                publish];

            [self.changeStateSubject sendNext:transitionConnection.signal];

            RACCompoundDisposable *disponsable = [RACCompoundDisposable compoundDisposable];
            [disponsable addDisposable:[transitionConnection.signal subscribe:subscriber]];
            [disponsable addDisposable:[transitionConnection connect]];

            return disponsable;
        }]
        ignoreValues];
}

@end
