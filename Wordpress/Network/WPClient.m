//
//  WPClient.m
//  Wordpress
//
//  Created by Evgeniy Yurtaev on 01/01/15.
//  Copyright (c) 2015 Evgeniy Yurtaev. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "WPClient.h"
#import "WPError.h"
#import "WPSite.h"

#import "WPSessionManager+Protected.h"

static NSString *const WPUserDefaultsKeyCurrentSite = @"WPUserDefaultsKeyCurrentSite";

@implementation WPClient

@synthesize currentSite = _currentSite;

- (NSError *)checkResponseObjectOnError:(MTLModel<MTLJSONSerializing> *)responseObject
{
    NSError *error = [super checkResponseObjectOnError:responseObject];
    if (!error) {
        if ([responseObject isKindOfClass:[WPError class]]) {
            error = [(WPError *)responseObject error];
        }
    }
    
    return error;
}

- (void)setCurrentSite:(WPSite *)currentSite
{
    if (_currentSite == currentSite) {
        return;
    }
    
    _currentSite = currentSite;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (_currentSite) {
        NSDictionary *dictionaryRepresentation = [MTLJSONAdapter JSONDictionaryFromModel:_currentSite];
        [userDefaults setObject:dictionaryRepresentation forKey:WPUserDefaultsKeyCurrentSite];
    } else {
        [userDefaults removeObjectForKey:WPUserDefaultsKeyCurrentSite];
    }
    [userDefaults synchronize];
}

- (WPSite *)currentSite
{
    if (!_currentSite) {
        NSDictionary *dictionaryRepresentation = [[NSUserDefaults standardUserDefaults] objectForKey:WPUserDefaultsKeyCurrentSite];
        
        NSError *error;
        _currentSite = [MTLJSONAdapter modelOfClass:[WPSite class] fromJSONDictionary:dictionaryRepresentation error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    NSAssert(_currentSite, @"`currentSite` can't be equal to nil");
    
    return _currentSite;
}

@end
