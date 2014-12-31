//
//  WPObjectsSerializer.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPObjectsSerializer.h"

@implementation WPObjectsSerializer

- (MTLModel<MTLJSONSerializing> *)serializeWithObjectClass:(Class)objectClass fromDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error
{
    return [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:dictionary error:error];
}

- (NSDictionary *)deserializeObject:(MTLModel<MTLJSONSerializing> *)object error:(NSError *__autoreleasing *)error
{
    return [MTLJSONAdapter JSONDictionaryFromModel:object];
}

@end

@implementation WPObjectsSerializer (RACExtension)

- (RACSignal *)rac_serializeWithObjectClass:(Class)objectClass fromDictionary:(NSDictionary *)dictionary
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSError *error;
        MTLModel<MTLJSONSerializing> *object = [self serializeWithObjectClass:objectClass fromDictionary:dictionary error:&error];
        
        if (!error) {
            [subscriber sendNext:object];
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:error];
        }
        
        return nil;
    }];
}

- (RACSignal *)rac_deserializeObject:(MTLModel<MTLJSONSerializing> *)object
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSError *error;
        NSDictionary *dictionary = [self deserializeObject:object error:&error];
        
        if (!error) {
            [subscriber sendNext:dictionary];
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:error];
        }
        
        return nil;
    }];
}

@end