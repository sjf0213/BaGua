//
//  BGEngine.m
//  BaGua
//
//  Created by 宋炬峰 on 16/9/12.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "BGEngine.h"
#import "BGClient.h"

const NSString* testURL = @"http://d.api.budejie.com/topic/recommend/bs0315-iphone-4.3/0-30.json?openudid=d41d8cd98f00b204e9800998ecf8427e617c93e8&appname=bs0315&asid=D39B26EB-4CB0-4789-85AD-B2E8F4A27BD1&client=iphone&device=iPhone%205&from=ios&jbk=0&mac=&market=&openudid=d41d8cd98f00b204e9800998ecf8427e617c93e8&udid=&ver=4.3";

@implementation BGEngine

+ (NSURLSessionDataTask *)getByUrl:(NSString *)url withBlock:(void (^)(NSDictionary *result, NSError *error))block{
    url = [NSString stringWithFormat:@"%@%@", [BGClient mainHostURL], url];
    DLog(@"KGGETurl = %@", url);
    return [[BGClient sharedClient] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseData) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary* result = responseData ;
            if (block) {
                block(result, nil);
            }
        });
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSDictionary dictionary], error);
        }
    }];
}

+ (NSURLSessionDataTask *)postByUrl:(NSString *)url postParam:(id)postParam withBlock:(void (^)(NSDictionary *result, NSError *error))block{
    DLog(@"KGPOSTurl = %@", url);
    url = [NSString stringWithFormat:@"%@%@", [BGClient mainHostURL], url];
    return [[BGClient sharedClient] POST:url parameters:postParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *err = nil;
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&err];
            if (block) {
                block(result, nil);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block([NSDictionary dictionary], error);
        }
    }];
}
+ (NSURLSessionDataTask *)postDataByUrl:(NSString *)url postData:(id)data withBlock:(void (^)(NSDictionary *result, NSError *error))block{
    url = [NSString stringWithFormat:@"%@%@", [BGClient mainHostURL], url];
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0){
        // 以下方法在iOS7上会出现图片上传的请求中缺少Content-Length的问题，见https://github.com/AFNetworking/AFNetworking/issues/1398
        return [[BGClient sharedClient] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFormData:data name:@"forum_image"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            DLog(@"AFKGPageEngine.uploadProgress = %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary* result = responseObject;
                if (block) {
                    block(result, nil);
                }
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                block([NSDictionary dictionary], error);
            }
        }];
    }else{///////////////////////////iOS7///////////////////////////
        NSString* tmpFilename = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
        NSURL* tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFilename]];
        
        // Create a multipart form request.
        NSMutableURLRequest *multipartRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
            [formData appendPartWithFormData:data name:@"forum_image"];
        } error:nil];
        
        // Dump multipart request into the temporary file.
        [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:multipartRequest
                                                  writingStreamContentsToFile:tmpFileUrl
                                                            completionHandler:^(NSError *error) {
                                                                
                                                                NSURLSessionUploadTask *uploadTask = [[BGClient sharedClient] uploadTaskWithRequest:multipartRequest fromFile:tmpFileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                    // Cleanup: remove temporary file.
                                                                    [[NSFileManager defaultManager] removeItemAtURL:tmpFileUrl error:nil];
                                                                    if (error) {
                                                                        if (block) {
                                                                            block([NSDictionary dictionary], error);
                                                                        }
                                                                    } else {
                                                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                            NSDictionary* result = responseObject;
                                                                            if (block) {
                                                                                block(result, nil);
                                                                            }
                                                                        });
                                                                    }
                                                                }];
                                                                // Start the file upload.
                                                                [uploadTask resume];
                                                            }];
        // 两个异步功能，无法返回uploadTask
        return nil;
    }
}

#pragma mark - 一级列表

+ (NSURLSessionDataTask *)homepageByParam:(NSDictionary*)param contentWithBlock:(void (^)(NSDictionary *result, NSError *error))block {
    NSString * url = [NSString stringWithString:testURL];
    return [BGEngine getByUrl:url withBlock:block];
}
@end
