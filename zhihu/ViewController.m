//
//  ViewController.m
//  zhihu
//
//  Created by 李佳 on 16/6/23.
//  Copyright © 2016年 LJ. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "LJIndexCell.h"
#import "LJDetailViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
{
    NSMutableArray  *aryData;
    NSMutableArray  *topAry, *titleAry, *topImgArray;
    UITableView     *tbView;
    NSInteger       dateCount;
    NSDictionary    *cacheDic;
    UIButton        *liveShowButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    aryData = @[].mutableCopy;
    topAry = @[].mutableCopy;
    titleAry = @[].mutableCopy;
    topImgArray = @[].mutableCopy;
    tbView = [[UITableView alloc] initWithFrame: CGRectMake(0,  0  , DEVICE_WIDTH, DEVICE_HEIGHT ) style:UITableViewStylePlain];
    tbView.dataSource = self;
    tbView.delegate   = self;
    tbView.tableFooterView = [UIView new];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.tableHeaderView = [self headerView];
    [self.view addSubview:tbView];

    WS(ws);

    tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws loadData];

    }];

    tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws loadMoreData];
    }];

    [self loadData];
}


- (UIView *)headerView
{
    if (!topAry.count) {
        return [UIView new];
    }
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200 * KSCALE) delegate:self placeholderImage:nil];
    
    cycleView.imageURLStringsGroup = topImgArray;
    cycleView.titlesGroup = titleAry;
    cycleView.autoScrollTimeInterval = 5;
    cycleView.hidesForSinglePage = YES;
    cycleView.showPageControl = NO;
    return cycleView;
}

- (void)loadData
{
    //提取缓存
    cacheDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheDic"];
//    if (cacheDic && [cacheDic isKindOfClass:[NSDictionary class]] && cacheDic.count) {
//        NSArray *story = [cacheDic objectForKey:@"stories"];
//        [aryData removeAllObjects];
//        [aryData addObjectsFromArray:story];
//
//        NSArray *topstories = [cacheDic objectForKey:@"top_stories"];
//        if (topstories && topstories.count > 0) {
//            [topAry removeAllObjects];
//            [topImgArray removeAllObjects];
//            [topAry addObjectsFromArray:topstories];
//            for (int i = 0; i < topstories.count; i++) {
//                NSDictionary *dic = topstories [i];
//                NSString *image = [dic objectForKey:@"image"];
//                NSString *title = [dic objectForKey:@"title"];
//                [topImgArray addObject:image];
//                [titleAry addObject:title];
//
//            }
//        }
//        WS(ws);
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            [tbView.mj_header endRefreshing];
//            if (topAry.count) {
//                tbView.tableHeaderView = [ws headerView];
//            }
//
//            [tbView reloadData];
//        });
//    }else{
        //没有缓存直接
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [Post getDataWithURL:ZH_LATEST_TIMELINE Block:^(id response, NSError *error) {
                if (response && [response isKindOfClass:[NSDictionary class]]) {
                    cacheDic = [(NSDictionary *)response copy];
                    [[NSUserDefaults standardUserDefaults] setObject:cacheDic forKey:@"cacheDic"];
                    [[NSUserDefaults standardUserDefaults] synchronize];


                    NSArray *story = [(NSDictionary *)response objectForKey:@"stories"];
                    [aryData removeAllObjects];
                    [aryData addObjectsFromArray:story];

                    NSArray *topstories = [(NSDictionary *)response objectForKey:@"top_stories"];
                    if (topstories && topstories.count > 0) {
                        [topAry removeAllObjects];
                        [topImgArray removeAllObjects];
                        [topAry addObjectsFromArray:topstories];
                        for (int i = 0; i < topstories.count; i++) {
                            NSDictionary *dic = topstories [i];
                            NSString *image = [dic objectForKey:@"image"];
                            NSString *title = [dic objectForKey:@"title"];
                            [topImgArray addObject:image];
                            [titleAry addObject:title];

                        }
                    }
                    WS(ws);

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [tbView.mj_header endRefreshing];
                        if (topAry.count) {
                            tbView.tableHeaderView = [ws headerView];
                        }
                        
                        [tbView reloadData];
                    });
                }
            }];
        });
//    }
}

- (void)loadMoreData
{
    //提取缓存
//    cacheDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheDic"];
//    if (cacheDic && [cacheDic isKindOfClass:[NSDictionary class]] && cacheDic.count) {
//
//
//    }else{

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow: -3600 * 24 * dateCount];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYYMMdd"];
            NSString *beforeDate = [dateFormatter stringFromDate:currentDate];
            [Post getDataWithURL:[NSString stringWithFormat:@"%@%@", ZH_BEFORE_TIMELINE, beforeDate] Block:^(id response, NSError *error) {
                if (response && [response isKindOfClass:[NSDictionary class]]) {
                    NSArray *story = [(NSDictionary *)response objectForKey:@"stories"];
                    [aryData addObjectsFromArray:story];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [tbView.mj_footer endRefreshing];
                    [tbView reloadData];
                });
                
                
                dateCount++;
            }];
            
        });
//    }

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (topAry.count) {
        NSDictionary *dic = [topAry objectAtIndex: index];
        NSString *contentID = [dic objectForKey:@"id"];
        LJDetailViewController *detailVC = [LJDetailViewController new];
        detailVC.contentID = contentID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return aryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    LJIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(cell == nil) {
        cell = [[LJIndexCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    if (aryData.count) {
        NSDictionary *dic = [aryData objectAtIndex:indexPath.row];
        [cell refreshWithData:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (aryData.count) {
        NSDictionary *dic = [aryData objectAtIndex:indexPath.row];
         NSString *contentID = [dic objectForKey:@"id"];
        LJDetailViewController *detailVC = [LJDetailViewController new];
        detailVC.contentID = contentID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
