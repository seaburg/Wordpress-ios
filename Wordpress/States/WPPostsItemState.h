//
//  WPPostsItemState.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol WPPostsItemState <NSObject>

- (NSString *)title;

- (NSString *)excerpt;

- (NSNumber *)numberOfComments;

// loadImage : -> RACSignal UIImage
- (RACSignal *)loadImage;

@end
