
//
//  Post.m
//  zhihu
//
//  Created by 李佳 on 16/6/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "Post.h"
#import "AFNetworking.h"
@implementation Post

+ (void)getDataWithURL: (NSString *)url Block: (void (^)(id response, NSError *error))block;
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSLog(@"url--   %@",  url);
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求地址：\n--%@ -- \n responseObject      %@", url, responseObject);
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,nil);

    }];
}


@end
