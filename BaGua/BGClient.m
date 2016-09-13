//
//  BGClient.m
//  BaGua
//
//  Created by 宋炬峰 on 16/9/12.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "BGClient.h"

NSString* host = @"d.api.budejie.com";

@implementation BGClient

+ (instancetype)sharedClient {
    static BGClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BGClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return _sharedClient;
}

+(NSString*)mainHostURL{
    return [NSString stringWithFormat:@"http://%@/", host];
}

@end
