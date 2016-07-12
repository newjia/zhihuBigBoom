


//
//  BaseViewController.m
//  zhihu
//
//  Created by 李佳 on 16/6/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <IWNavView>

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    self.navView.btnBack.hidden = !self.navigationController.viewControllers.count ;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView = [[IWNavView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 64)];
    self.navView.delegate = self;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];

}

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
