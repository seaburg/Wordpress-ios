//
//  WPPostViewModel.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 20/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol WPPostViewModel <NSObject>

// state : -> RACSignal WPPostState
- (RACSignal *)state;

@end
