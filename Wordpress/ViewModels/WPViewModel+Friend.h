//
//  WPViewModel+Friend.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "WPViewModel.h"

@class RACSignal;

@interface WPViewModel (Friend)

// closeSignal : RACSignal _
@property (strong, nonatomic) RACSignal *closeSignal;

// prepareForUse : -> RACSignal _
- (RACSignal *)prepareForUse;

@end
