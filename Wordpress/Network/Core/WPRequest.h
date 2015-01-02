//
//  WPRequest.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WPRequest : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) MTLModel<MTLJSONSerializing> *routeObject;

+ (NSString *)pathPattern;

+ (NSString *)method;

+ (Class)responseClass;

@end
