//
//  WPPostCellComponent.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 19/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ComponentKit/CKCompositeComponent.h>

#import "WPPostsItemState.h"

@interface WPPostCellComponent : CKCompositeComponent

+ (instancetype)newWithPostsItemState:(id<WPPostsItemState>)state tapHandler:(void(^)(void))tapHandler;

@end
