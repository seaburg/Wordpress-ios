//
//  WPPostHeaderComponent.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 27/06/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <ComponentKit/ComponentKit.h>

#import "WPPostState.h"

@interface WPPostHeaderComponent : CKCompositeComponent

+ (instancetype)newWithPostState:(id<WPPostState>)postState size:(const CKComponentSize &)size;

@end
