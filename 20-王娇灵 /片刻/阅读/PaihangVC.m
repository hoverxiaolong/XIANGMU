//
//  PaihangVC.m
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "PaihangVC.h"
#import "HCRankListCell.h"
#import "HCRankListModel.h"
#import "HCRankSongViewController.h"
#import "MYNetWorkTool.h"
#import "NSObject+MJKeyValue.h"
#import "JXLDayAndNightMode.h"

/*-----screenSize-----*/
#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCScreenHeight HCScreen.size.height

#define HCUrl @"http://tingapi.ting.baidu.com/v1/restserver/ting"

#define HCParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}

/*-----Spacing-----*/
#define HCHorizontalSpacing 20

#define HCCommonSpacing 10

#define HCVerticalSpacing 5


@interface PaihangVC ()

@property (nonatomic ,strong) NSMutableArray *rankListArray;

@end

@implementation PaihangVC

- (NSMutableArray *)rankListArray
{
    if (!_rankListArray) {
        _rankListArray = [NSMutableArray array];
        [self loadRankData];
    }
    return _rankListArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self config];
}

- (void)config {
    [self.view jxl_setDayMode:^(UIView *view) {
        
        self.tableView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        
        self.tableView.backgroundColor = [UIColor blackColor];
    }];
    
    [self.navigationController.navigationBar jxl_setDayMode:^(UIView *view) {
        UINavigationBar *bar = (UINavigationBar *)view;
        bar.barStyle = UIBarStyleDefault;
        bar.barTintColor = [UIColor redColor];
    } nightMode:^(UIView *view) {
        UINavigationBar *bar = (UINavigationBar *)view;
        bar.barStyle = UIBarStyleDefault;
        bar.barTintColor = [UIColor greenColor];
    }];
   
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCRankListModel *list = self.rankListArray[indexPath.row];
    HCRankListCell *cell = [HCRankListCell rankCellWithTableView:tableView songInfoArray:list.content];
    cell.rankListImage = list.pic_s260;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height = HCScreenWidth / 3;
    return height + 2 * HCVerticalSpacing;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCRankListModel *list = self.rankListArray[indexPath.row];
    HCRankSongViewController *vc = [[HCRankSongViewController alloc] init];
    vc.rankType = list;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - loadData
- (void)loadRankData
{
    [MYNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.billboard.billCategory",@"kflag":@"1") response:^(id response) {
        for (NSDictionary *dict in response[@"content"]) {
            HCRankListModel *rankList = [HCRankListModel mj_objectWithKeyValues:dict];
            [self.rankListArray addObject:rankList];
        }
        [self.tableView reloadData];
    }];
}


@end
