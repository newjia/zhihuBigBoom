//
//  QPLiveSession.h
//  LiveCapture
//
//  Created by yly on 16/3/2.
//  Copyright © 2016年 lyle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QPLConfiguration.h"

@protocol QPLiveSessionDelegate;

@interface QPLiveSession : NSObject

@property (nonatomic, assign) BOOL enableSkin;
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;
@property (nonatomic, weak) id<QPLiveSessionDelegate> delegate;

+ (NSString *)version;

- (instancetype)initWithConfiguration:(QPLConfiguration *)configuration;

- (UIView *)previewView;

- (void)startPreview;
- (void)stopPreview;

- (void)rotateCamera;
- (void)focusAtAdjustedPoint:(CGPoint)point autoFocus:(BOOL)autoFocus;

/**
 *更新live配置，可以更新码率和帧率，但是只能在connectServer之前调用
 */
- (void)updateConfiguration:(void(^)(QPLConfiguration *configuration))block;

- (void)connectServer;
- (void)connectServerWithURL:(NSString *)url;

- (void)disconnectServer;

- (QPLDebugInfo *)dumpDebugInfo;

- (NSInteger)videoBitRate;
@end


@protocol QPLiveSessionDelegate <NSObject>

- (void)liveSession:(QPLiveSession *)session error:(NSError *)error;

/**
 * 网络很慢，已经不建议直播
 */
- (void)liveSessionNetworkSlow:(QPLiveSession *)session;

@end