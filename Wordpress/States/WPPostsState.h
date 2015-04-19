//
//  WPPostsState.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class RACSequence;

@protocol WPPostsState <NSObject>

- (BOOL)nextPageExist;

// items : -> RACSequence
- (RACSequence *)items;

@end
