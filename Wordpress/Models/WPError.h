//
//  WPError.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WPError : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *message;

- (NSError *)error;

@end
