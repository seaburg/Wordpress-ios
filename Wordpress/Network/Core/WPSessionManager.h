//
//  WPSessionManager.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class RACSignal;
@class WPRequest;
@class WPObjectsSerializer;

@interface WPSessionManager : AFHTTPSessionManager

@property (strong, atomic) WPObjectsSerializer *objectsSerializer;

+ (instancetype)sharedInstance;

+ (void)setSharedInstance:(WPSessionManager *)sharedInstance;

// performRequest: : -> RACSignal {request.class.responceClass}
- (RACSignal *)performRequest:(WPRequest *)request;

@end
