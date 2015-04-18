//
//  WPSplashState.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 18/04/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPSplashState <NSObject>

- (BOOL)loading;

- (NSString *)errorMessage;

@end
