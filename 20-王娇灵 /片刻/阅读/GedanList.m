//
//  GedanList.m
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "GedanList.h"
#import "MYPublicTableView.h"
#import "MYPublicHeadView.h"
#import "MYPublicSonglistModel.h"
#import "MYPublicSongDetailModel.h"
#import "MYCreatTool.h"
#import "UIImageView+WebCache.h"
#import "MYBlurViewTool.h"
#import "MYNetWorkTool.h"
#import "NSObject+MJKeyValue.h"

/*-----screenSize-----*/
#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCScreenHeight HCScreen.size.height

#define HCUrl @"http://tingapi.ting.baidu.com/v1/restserver/ting"

#define HCParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}
#define HCMusic @"http://ting.baidu.com/data/music/links"

@interface GedanList ()

@property (nonatomic ,weak) UIImageView *backGroundImageView;
@property (nonatomic ,weak) UIScrollView *scrollView;
@property (nonatomic ,strong) MYPublicTableView *tableView;
@property (nonatomic ,strong) MYPublicHeadView *headView;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;



@end

@implementation GedanList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBackGroundView];
    [self setUpScrollView];
    self.songListArrayM = [NSMutableArray array];
    self.songIdsArrayM = [NSMutableArray array];
    [self loadSongList];
    
}

- (void)setUpBackGroundView
{
    self.backGroundImageView = [MYCreatTool imageViewWithView:self.view];
    self.backGroundImageView.frame = CGRectMake(-HCScreenWidth,-HCScreenHeight, 3 * HCScreenWidth, 3 * HCScreenHeight);
    [self.backGroundImageView sd_setImageWithURL:[NSURL URLWithString:self.pic]];
    [MYBlurViewTool blurView:self.backGroundImageView style:UIBarStyleDefault];
}
- (void)setUpScrollView
{
    
    self.scrollView = [MYCreatTool scrollViewWithView:self.view];
    self.scrollView.frame = self.view.frame;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(0, HCScreenHeight + HCScreenWidth * 0.5 +60);
    
    self.headView = [[MYPublicHeadView alloc] initWithFullHead:arc4random() % 2];
    self.headView.frame = CGRectMake(0, 40, HCScreenWidth, HCScreenWidth * 0.5 + 60);
    [self.scrollView addSubview:self.headView];
    
    self.tableView = [[MYPublicTableView alloc] init];
    self.tableView.frame = CGRectMake(0, HCScreenWidth * 0.5 + 100, HCScreenWidth, HCScreenHeight);
    [self.scrollView addSubview:self.tableView];
}

#pragma mark - loadData
- (void)loadSongList
{
    [MYNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.diy.gedanInfo",@"listid":self.listid) response:^(id response) {
        MYPublicSonglistModel *songList = [MYPublicSonglistModel mj_objectWithKeyValues:response];
        NSInteger i = 0;
        for (NSDictionary *dict in songList.content) {
            MYPublicSongDetailModel *songDetail = [MYPublicSongDetailModel mj_objectWithKeyValues:dict];
            songDetail.num = ++i;
            [self.songListArrayM addObject:songDetail];
            [self.songIdsArrayM addObject:songDetail.song_id];
        }
        [self.headView setMenuList:songList];
        [self.tableView setSongList:self.songListArrayM songIds:self.songIdsArrayM];
    }];
}



@end
