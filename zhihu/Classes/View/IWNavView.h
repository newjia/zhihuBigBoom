//
//  IWNavView.h
//  Dome
//
//  Created by IWANT on 15/7/6.
//  Copyright (c) 2015年 IWANT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IWNavView <NSObject>
-(void)popVC;
@end
  
@interface IWNavView : UIView


@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *leftButton;

@property (nonatomic, strong) UIButton  *btnBack;
@property (nonatomic, strong) id<IWNavView> delegate;
@property (nonatomic, strong) UILabel   *navTitleLabel;

- (void)setTitleLabelWithString: (NSString *)title;
- (void)setLeftButtonWithString: (NSString *)title;
- (void)setRightButtonWithString: (NSString *)title;

@end
