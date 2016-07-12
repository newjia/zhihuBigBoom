
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
    [session GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求地址：\n--%@ -- \n responseObject      %@", url, responseObject);
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil,nil);
    }];

}


@end
