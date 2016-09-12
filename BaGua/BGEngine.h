//
//  BGEngine.h
//  BaGua
//
//  Created by 宋炬峰 on 16/9/12.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGEngine : NSObject

+ (NSURLSessionDataTask *)homepageByParam:(NSDictionary*)param contentWithBlock:(void (^)(NSDictionary *result, NSError *error))block;
@end
