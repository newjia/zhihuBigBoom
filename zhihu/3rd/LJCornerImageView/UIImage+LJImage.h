//
//  UIImage+LJImage.h
//  Cornaer
//
//  Created by 李佳 on 16/5/31.
//  Copyright © 2016年 李佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LJImageView)
/**
 *  用该行代码进行网络图片的获取
 *
 *  @param urlStr         图片的网络地址
 *  @param placeHolderStr 占位本地图片
 *  @param radius         圆角半径
 */
- (void)LJ_loadImageUrlStr:(NSString *)urlStr placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius;
- (void)addCorner: (CGFloat)cornerRadius;

@end


@interface UIImage (LJImage)
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
- (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius size:(CGSize)sizeToFit;
@end
