


//
//  LJDetailViewController.m
//  zhihu
//
//  Created by 李佳 on 16/6/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "LJDetailViewController.h"

@interface LJDetailViewController () <UIWebViewDelegate>
{
    UIView *topView, *translentView;
    UIImageView *topIV;
    UITextView *topTitle;
    UILabel *autherLabel;
    UIWebView *wbView;
}
@end

@implementation LJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.hidden = YES;
    //自定义的后退键
    [self initBackButton];

    //顶部的大图
//    [self initTopImageView];

    // 初始化WebView
    [self initWebView];

    [self.view bringSubviewToFront:translentView];

    [self loadData];

}

- (void)initBackButton
{
    translentView = [[UIView alloc] initWithFrame:self.navView.bounds];
    [self.view addSubview:translentView];
    UIImageView *transBackIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_newBack"]];
    [translentView addSubview:transBackIV];
    [transBackIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(translentView.mas_top).offset(22 + 20);
        make.left.mas_equalTo(13 * KSCALE);
        make.size.mas_equalTo(CGSizeMake(25 * KSCALE, 25 * KSCALE));
    }];

    UIButton *transBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    transBackButton.backgroundColor = [UIColor clearColor];
    [translentView addSubview:transBackButton];
    [transBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((25 + 13 * 2) * KSCALE);
    }];
    [transBackButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];


}

- (void)initTopImageView
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200 * KSCALE)];
    [self.view addSubview:topView];

    topIV  = [[UIImageView alloc] initWithFrame:topView.bounds];
    topIV.contentMode = UIViewContentModeScaleAspectFill;
    topIV.clipsToBounds = YES;
    [topView addSubview:topIV];

    topTitle = [[UITextView alloc] initWithFrame:CGRectMake(8, 200 * KSCALE - 60 * KSCALE, DEVICE_WIDTH - 16, 50 * KSCALE)];
    topTitle.editable = NO;
    topTitle.font = [UIFont boldSystemFontOfSize:16 * KSCALE];
    topTitle.textColor = [UIColor whiteColor];
    topTitle.backgroundColor = [UIColor clearColor];
    [topView addSubview:topTitle];

    autherLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * KSCALE, 200 * KSCALE - 15 * KSCALE, DEVICE_WIDTH - 16 * KSCALE, 10 * KSCALE)];
    autherLabel.textColor = [UIColor whiteColor];
    autherLabel.textAlignment = NSTextAlignmentRight;
    autherLabel.font = [UIFont systemFontOfSize:9 * KSCALE];
    [topView addSubview:autherLabel];
}

- (void)initWebView
{
    wbView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT )];
    wbView.delegate = self;
    wbView.scrollView.scrollsToTop = NO;
    wbView.scalesPageToFit = YES;
    [self.view addSubview:wbView];
}

    // 使用JS 进行图片自适应
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    [webView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=%f;"// 图片宽度
     "for(i=0;i  maxwidth){"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('avatar')[0].appendChild(script);", DEVICE_WIDTH]];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

- (void)loadData
{
    [SVProgressHUD show];
    if (!topView) {

        topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200 * KSCALE)];
        [self.view addSubview:topView];

        topIV  = [[UIImageView alloc] initWithFrame:topView.bounds];
        topIV.contentMode = UIViewContentModeScaleAspectFill;
        topIV.clipsToBounds = YES;
        [topView addSubview:topIV];

        topTitle = [[UITextView alloc] initWithFrame:CGRectMake(8, 200 * KSCALE - 60 * KSCALE, DEVICE_WIDTH - 16, 50 * KSCALE)];
        topTitle.editable = NO;
        topTitle.font = [UIFont boldSystemFontOfSize:16 * KSCALE];
        topTitle.textColor = [UIColor whiteColor];
        topTitle.backgroundColor = [UIColor clearColor];
        [topView addSubview:topTitle];

        autherLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * KSCALE, 200 * KSCALE - 15 * KSCALE, DEVICE_WIDTH - 16 * KSCALE, 10 * KSCALE)];
        autherLabel.textColor = [UIColor whiteColor];
        autherLabel.textAlignment = NSTextAlignmentRight;
        autherLabel.font = [UIFont systemFontOfSize:9 * KSCALE];
        [topView addSubview:autherLabel];

        [wbView.scrollView addSubview:topView];
        wbView.scrollView.subviews[0].frame = CGRectMake(0, 200 * KSCALE, DEVICE_WIDTH, DEVICE_HEIGHT -200 * KSCALE);
        
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [Post getDataWithURL:[NSString stringWithFormat:@"%@%@", ZH_DETAIL, _contentID] Block:^(id response, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"网络故障"];
                return ;
            }
            NSString *bodyHtml = [(NSDictionary *)response objectForKey:@"body"];
            //如果html没有head，添加head，以及各种样式，是为了能让图片缩放
            bodyHtml =  [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "body {margin:%f;font-size: %f;}\n"
                         "a {text-decoration: none; color:lightblue}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body>%@</body> \n"
                         "</html>", 42.0, 32.0 * (DEVICE_WIDTH > 320 ? 1.1 : 1),bodyHtml];;
            [wbView loadHTMLString:bodyHtml baseURL:nil];

            NSString *image = [(NSDictionary *)response objectForKey:@"image"];
            [topIV LJ_loadImageUrlStr:image placeHolderImageName:nil radius:0];

            NSString *title = [(NSDictionary *)response objectForKey:@"title"];
            topTitle.text = title;

            NSString *image_source = [(NSDictionary *)response objectForKey:@"image_source"];
            autherLabel.text = [NSString stringWithFormat:@"图片 : %@", image_source];
            [SVProgressHUD dismiss];
        }];
    });
}

- (void)showMe
{
    [SVProgressHUD showSuccessWithStatus: @"IT'S OK"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
