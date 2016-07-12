//
//  QPLConfiguration.h
//  QPLive
//
//  Created by yly on 16/3/8.
//  Copyright © 2016年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, QPLConnectStatus) {
    QPLConnectStatusNone,
    QPLConnectStatusStart,
    QPLConnectStatusSuccess,
    QPLConnectStatusFailed,
    QPLConnectStatusBreak,
};

@interface QPLDebugInfo : NSObject

@property (nonatomic, strong) NSString* cameraPresent;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) CGFloat fps;
@property (nonatomic, assign) CGFloat speed;//单位 byte
@property (nonatomic, assign) UInt64 localBufferSize;//单位 byte
@property (nonatomic, assign) UInt64 localBufferCount;
@property (nonatomic, assign) CGFloat localDelay;//单位 ms
@property (nonatomic, assign) UInt64 pushSize;//单位 byte
@property (nonatomic, assign) QPLConnectStatus connectStatus;
@property (nonatomic, assign) double connectStatusChangeTime;//timeIntervalSince1970

/**
 *所有编码帧数
 */
@property (nonatomic, assign) NSUInteger encodeFrameCount;
/**
 *所有发送帧数
 */
@property (nonatomic, assign) NSUInteger pushFrameCount;
/**
 *周期性延迟 单位 ms
 */
@property (nonatomic, assign) double cycleDelay;
@end


@interface QPLConfiguration : NSObject

@property (nonatomic, strong) NSString* preset;
@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, strong) NSString* url;
/**
 *最大码率，网速变化的时候会根据这个值来提供建议码率
 *默认 1500 * 1000
 */
@property (nonatomic, assign) NSInteger videoMaxBitRate;
/**
 *最小码率，网速变化的时候会根据这个值来提供建议码率
 *默认 400 * 1000
 */
@property (nonatomic, assign) NSInteger videoMinBitRate;
/**
 *默认码率，在最大码率和最小码率之间
 *默认 600 * 1000
 */
@property (nonatomic, assign) NSInteger videoBitRate;
@property (nonatomic, assign) NSInteger audioBitRate;//default 64 * 1000
@property (nonatomic, assign) NSInteger fps;//default 30

@property (nonatomic, strong) QPLDebugInfo* debugInfo;

@end