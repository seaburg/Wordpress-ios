//
//  WPObjectsSerializer.h
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface WPObjectsSerializer : NSObject

- (MTLModel<MTLJSONSerializing> *)serializeWithObjectClass:(Class)objectClass fromDictionary:(NSDictionary *)dictionary error:(NSError **)error;

- (NSDictionary *)deserializeObject:(MTLModel<MTLJSONSerializing> *)object error:(NSError **)error;

@end

@class RACSignal;
@interface WPObjectsSerializer (RACExtension)

// rac_serializeWithObjectClass:fromDictionary: -> RACSignal objectClass
- (RACSignal *)rac_serializeWithObjectClass:(Class)objectClass fromDictionary:(NSDictionary *)dictionary;

// rac_deserializeObject: : -> RACSignal NSDictionary
- (RACSignal *)rac_deserializeObject:(MTLModel<MTLJSONSerializing> *)object;

@end
