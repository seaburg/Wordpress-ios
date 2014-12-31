//
//  WPSessionManager+Protected.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "WPSessionManager+Protected.h"

@implementation WPSessionManager (Protected)

- (void)prepareRequestParams:(NSMutableDictionary *)params
{
}

- (NSError *)checkResponseObjectOnError:(MTLModel<MTLJSONSerializing> *)responseObject
{
    return nil;
}

@end
