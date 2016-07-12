//  IWNavView.m
//  Dome
//
//  Created by IWANT on 15/7/6.
//  Copyright (c) 2015年 IWANT. All rights reserved.
//

#import "IWNavView.h"

@implementation IWNavView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 1); // [UIColor colorWithRed:41/255.0 green:181/255.0 blue:170/255.0 alpha:1];23 40
        
        self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnBack.frame = CGRectMake(0, 20, 50, 44);
        self.btnBack.backgroundColor = [UIColor clearColor];
        [self.btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *img = [UIImage imageNamed:@"NavBack.png"];
        self.btnBack.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
        [self.btnBack setImage:img forState:UIControlStateNormal];
        [self.btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnBack];

        self.navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.btnBack.frame.size.width, 20, [[UIScreen mainScreen]bounds].size.width-self.btnBack.frame.size.width*2, 40)];
        self.navTitleLabel.backgroundColor = [UIColor clearColor];
        self.navTitleLabel.textColor = [UIColor whiteColor];
        self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.navTitleLabel];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame = CGRectZero;
        self.titleLabel.textColor = [UIColor whiteColor];

        [self addSubview:self.titleLabel];

    }
    return self;
}

-(void)clickBack
{
    [self.delegate popVC];
}

- (void)setTitleLabelWithString: (NSString *)title
{
    if ([title isMemberOfClass:[NSNull class]] || title.length == 0) {
        return;
    }
    //计算文本的高度
    CGRect frame = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0]} context:nil];

    CGFloat width = frame.size.width;
    CGFloat maxWidth = DEVICE_WIDTH - 120;
    if (width > maxWidth) {
        width = maxWidth;
    }
    self.titleLabel.frame = CGRectMake(0, 0, width, frame.size.height);
    self.titleLabel.center = CGPointMake(DEVICE_WIDTH / 2, self.frame.size.height / 2 + 10);
    self.titleLabel.text = title;
    self.titleLabel.font =  [UIFont systemFontOfSize:18.0];//IWFont(18.0);
}

- (void)setLeftButtonWithString: (NSString *)title
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 20, 80, 44);
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.leftButton];
    //    self.leftButton.textColor = [UIColor whiteColor];
}

- (void)setRightButtonWithString: (NSString *)title
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(DEVICE_WIDTH - 80, 20, 80, 44);
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.leftButton];
    //    self.leftButton.textColor = [UIColor whiteColor];
}


@end
