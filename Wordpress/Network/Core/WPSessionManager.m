//
//  WPSessionManager.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 31/12/14.
//  Copyright (c) 2014 Evgeniy Yurtaev. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WPSessionManager.h"
#import "WPObjectsSerializer.h"
#import "WPRequest.h"

#import "WPSessionManager+Protected.h"
#import "AFURLSessionManager+RACExtension.h"

static WPSessionManager *_sharedInstance;

@interface WPSessionManager ()

@property (strong, nonatomic) RACScheduler *responseSerializeScheduler;

@end

@implementation WPSessionManager

+ (instancetype)sharedInstance
{
    return _sharedInstance;
}

+ (void)setSharedInstance:(WPSessionManager *)sharedInstance
{
    _sharedInstance = sharedInstance;
}

- (void)commonInit
{
    NSString *responseSerializeSchedulerName = @"com.wordpress.sessionManager.responseSerializeScheduler";
    self.responseSerializeScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault name:responseSerializeSchedulerName];
    
    char completionQueueLabel[] = "com.wordpress.sessionManager.completionQueue";
    self.completionQueue = dispatch_queue_create(completionQueueLabel, DISPATCH_QUEUE_CONCURRENT);
    
    self.objectsSerializer = [[WPObjectsSerializer alloc] init];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (RACSignal *)performRequest:(WPRequest *)request
{
    return [[[[RACSignal defer:^RACSignal *{
        
            RACSignal *URLSignal = [[self pathFromPatternPath:[[request class] pathPattern] routeObject:request.routeObject]
                map:^id(NSString *path) {
                    return [NSURL URLWithString:path relativeToURL:self.baseURL];
                }];
        
            RACSignal *paramsSignal = [[self.objectsSerializer rac_deserializeObject:request]
                map:^id(NSDictionary *params) {
                    
                    NSMutableDictionary *mutableParams = [params mutableCopy];
                    [self prepareRequestParams:mutableParams];
                    
                    return [mutableParams copy];
                }];
        
            return [RACSignal combineLatest:@[ URLSignal, paramsSignal ]];
        }]
        // Serialize URL request. (NSURL, NSDictionary) -> RACSignal NSURLRequest
        flattenMap:^RACStream *(RACTuple *value) {
            
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                RACTupleUnpack(NSURL *url, NSDictionary *params) = value;
                NSString *method = [[request class] method];
                
                NSError *error;
                NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                               URLString:[url absoluteString]
                                                                              parameters:params
                                                                                   error:&error];
                if (!error) {
                    [subscriber sendNext:[request copy]];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:error];
                }
                
                return nil;
            }];
        }]
        // Send request and serialize response object. NSURLRequest -> RACSignal {request.class.responceClass}
        flattenMap:^RACStream *(NSURLRequest *URLRequest) {
            return [[[[self rac_dataTaskWithRequest:URLRequest]
                flattenMap:^RACStream *(NSDictionary *responseDictionary) {
                    
                    return [self.objectsSerializer rac_serializeWithObjectClass:[[request class] responseClass] fromDictionary:responseDictionary];
                }]
                subscribeOn:self.responseSerializeScheduler]
                deliverOn:[RACScheduler currentScheduler]];
        }]
        try:^BOOL(MTLModel<MTLJSONSerializing> *responseObject, NSError *__autoreleasing *errorPtr) {
            
            NSError *error = [self checkResponseObjectOnError:responseObject];
            if (error) {
                if (errorPtr) {
                    *errorPtr = error;
                }
                return NO;
            } else {
                return YES;
            }
        }];
}

- (RACSignal *)pathFromPatternPath:(NSString *)patternPath routeObject:(MTLModel<MTLJSONSerializing> *)routeObject
{
    return [[[RACSignal defer:^RACSignal *{
            return [self.objectsSerializer rac_deserializeObject:routeObject];
        }]
        aggregateWithStart:nil reduce:^id(NSDictionary *running, NSDictionary *next) {
            
            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:running];
            [result addEntriesFromDictionary:next];
            
            return [result copy];
        }]
        map:^id(NSDictionary *params) {
            
            NSMutableString *path = [NSMutableString stringWithString:patternPath];
            while (YES) {
                NSRange range = [path rangeOfString:@":\\w+" options:NSRegularExpressionSearch];
                if (range.length == 0) {
                    break;
                }
                
                NSString *key = [path substringWithRange:NSMakeRange(range.location + 1, range.length - 1)];
                NSString *value = [params[key] description];
                NSCAssert(value != nil, @"value with `%@` key should contain in route objects", key);
                
                [path replaceCharactersInRange:range withString:value];
            }
            
            return [path copy];
        }]
        ;
}

@end
