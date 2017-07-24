


//
//  LJIndexCell.m
//  zhihu
//
//  Created by 李佳 on 16/6/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJIndexCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation LJIndexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{

    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, DEVICE_WIDTH - 20, 70)];
    [self.contentView addSubview:bgView];

    CAShapeLayer *cornerLayer = [CAShapeLayer layer];
    cornerLayer.frame = bgView.bounds;
    cornerLayer.path = [[UIBezierPath bezierPathWithRoundedRect:bgView.bounds cornerRadius:5] CGPath];
    cornerLayer.fillColor = [UIColor whiteColor].CGColor;
    cornerLayer.borderColor = [UIColor blackColor].CGColor;
    cornerLayer.borderWidth = .5;

    [cornerLayer setShadowOpacity: .5];
    cornerLayer.shadowOffset = CGSizeMake(0, 0);
    cornerLayer.shadowColor = [UIColor grayColor].CGColor;

    [cornerLayer setShadowPath:[[UIBezierPath bezierPathWithRect:bgView.bounds] CGPath]];
    cornerLayer.rasterizationScale = [UIScreen mainScreen].scale;

    [bgView.layer addSublayer:cornerLayer];

    logIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    logIV.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:logIV];

    titleTV = [[UITextView alloc] initWithFrame:CGRectMake(80, 0, DEVICE_WIDTH - 100 - 15, 50)];
    titleTV.font = [UIFont systemFontOfSize:14];
    titleTV.backgroundColor = [UIColor clearColor];
    titleTV.textColor = [UIColor blackColor];
    titleTV.userInteractionEnabled = NO;
    [bgView addSubview:titleTV];
}

- (void)refreshWithData: (NSDictionary *)info
{
    titleTV.text = [info objectForKey:@"title"];
    NSArray *imgS = [info objectForKey:@"images"];
    NSString *image = [imgS firstObject];
    [logIV LJ_loadImageUrlStr:image placeHolderImageName:@"me_defaultGirl" radius:5];

}

@end
