//
//  Post.h
//  zhihu
//
//  Created by 李佳 on 16/6/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

+ (void)getDataWithURL: (NSString *)url Block: (void (^)(id response, NSError *error))block;

@end
 