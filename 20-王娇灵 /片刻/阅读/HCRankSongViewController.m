//
//  HCRankSongViewController.m
//  美物心语
//
//  Created by qingyun on 16/9/5.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import "HCRankSongViewController.h"
#import "HCRankListModel.h"
#import "MYPublicHeadView.h"
#import "MYPublicTableView.h"
#import "MYPublicSongDetailModel.h"
#import "MYCreatTool.h"
#import "UIImageView+WebCache.h"
#import "MYBlurViewTool.h"
#import "MYNetWorkTool.h"
#import "NSObject+MJKeyValue.h"
#import "JXLDayAndNightMode.h"
#import "MYPromptTool.h"
#import "SQLHandler.h"

/*-----screenSize-----*/
#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCScreenHeight HCScreen.size.height

#define HCCommonSpacing 10

#define HCUrl @"http://tingapi.ting.baidu.com/v1/restserver/ting"

#define HCParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}


@interface HCRankSongViewController ()
@property (nonatomic ,weak) UIImageView *backGroundImageView;
@property (nonatomic ,strong) MYPublicTableView *publicTableView;
@property (nonatomic ,strong) NSMutableArray *rankArray;
@property (nonatomic ,strong) NSMutableArray *songIds;
@end
@implementation HCRankSongViewController
- (void)setRankType:(HCRankListModel *)rankType
{
    _rankType = rankType;
    [self loadRankDetail];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rankArray = [NSMutableArray array];
    self.songIds = [NSMutableArray array];
    [self setUpBackgroundView];
    [self setUpTableView];
    [self setUpTableViewHeader];
    [self config];
}

- (void)config {
    [self.view jxl_setDayMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor blackColor];
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


- (void)setUpBackgroundView
{
    self.backGroundImageView = [MYCreatTool imageViewWithView:self.view];
    self.backGroundImageView.frame = CGRectMake(-HCScreenWidth,-HCScreenHeight, 3 * HCScreenWidth, 3 * HCScreenHeight);
    [self.backGroundImageView sd_setImageWithURL:[NSURL URLWithString:self.rankType.pic_s444]];
    [MYBlurViewTool blurView:self.backGroundImageView style:UIBarStyleDefault];
}
- (void)setUpTableView
{
    self.publicTableView = [[MYPublicTableView alloc] init];
    self.publicTableView.frame = self.view.frame;
    __weak typeof(self) weakSelf = self;
    [self.publicTableView setShoucang:^(NSInteger index) {
        [MYPromptTool promptModeText:@"已收藏" afterDelay:1];
        MYPublicSongDetailModel *musicModel = [[MYPublicSongDetailModel alloc] init];
        
        musicModel.song_id = weakSelf.responseObject[@"song_list"][index][@"song_id"];
        musicModel.title = weakSelf.responseObject[@"song_list"][index][@"title"];
        musicModel.pic_small = weakSelf.responseObject[@"song_list"][index][@"pic_small"];
        
        [[SQLHandler shareInstance] insert:musicModel];
        
    }];

    [self.view addSubview:self.publicTableView];
}
- (void)setUpTableViewHeader
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth, HCScreenWidth * 0.6)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:view.frame];
    [image sd_setImageWithURL:[NSURL URLWithString:self.rankType.pic_s444]];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(2 * HCCommonSpacing, HCScreenWidth * 0.5, HCScreenWidth, 25)];
    name.textColor = [UIColor whiteColor];
    name.text = [NSString stringWithFormat:@"%@",self.rankType.name];
    [view addSubview:image];
    [view addSubview:name];
    self.publicTableView.tableHeaderView = view;
}
#pragma mark - loadData
- (void)loadRankDetail
{
    [MYNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.billboard.billList",@"offset":@"0",@"size":@"100",@"type":self.rankType.type) response:^(id response) {
        NSInteger i = 0;
        if ([response[@"song_list"] isKindOfClass:[NSNull class]]) {
            return ;
        }
        for (NSDictionary *dict in response[@"song_list"]) {
            MYPublicSongDetailModel *songDetail = [MYPublicSongDetailModel mj_objectWithKeyValues:dict];
            self.responseObject = [response copy];
            songDetail.num = ++i;
            [self.rankArray addObject:songDetail];
            [self.songIds addObject:songDetail.song_id];
        }
        [self.publicTableView setSongList:self.rankArray songIds:self.songIds];
    }];
}
@end
