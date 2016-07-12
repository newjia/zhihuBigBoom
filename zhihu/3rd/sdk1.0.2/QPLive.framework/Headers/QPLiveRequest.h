//
//  QPLiveRequest.h
//  QPLive
//
//  Created by zhangwx on 16/4/14.
//  Copyright © 2016年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPLiveRequest : NSObject

- (void)requestCreateLiveWithDomain:(NSString *)domain
                            success:(void(^)(NSString *pushUrl, NSString *pullUrl, NSString *recordUrl))success
                            failure:(void(^)(NSError *error))failure;
@end
