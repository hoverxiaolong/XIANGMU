//
//  XinquListVC.m
//  美物心语
//
//  Created by qingyun on 16/9/4.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "XinquListVC.h"
#import "MYPublicTableView.h"
#import "MYPublicHeadView.h"
#import "MYPublicSonglistModel.h"
#import "MYPublicSongDetailModel.h"
#import "UIImageView+WebCache.h"
#import "MYCreatTool.h"
#import "MYBlurViewTool.h"
#import "MYNetWorkTool.h"
#import "NSObject+MJKeyValue.h"
#import "MYPromptTool.h"
#import "JXLDayAndNightMode.h"
#import "ShoucangViewController.h"
#import "SQLHandler.h"

/*-----screenSize-----*/
#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCScreenHeight HCScreen.size.height

#define HCUrl @"http://tingapi.ting.baidu.com/v1/restserver/ting"

#define HCParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}
#define HCMusic @"http://ting.baidu.com/data/music/links"


@interface XinquListVC ()

@property (nonatomic ,weak) UIImageView *backGroundImageView;
@property (nonatomic ,weak) UIScrollView *scrollView;
@property (nonatomic ,strong) MYPublicTableView *tableView;
@property (nonatomic ,strong) MYPublicHeadView *headView;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;

@end

@implementation XinquListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    
    [self setUpBackGroundView];
    [self setUpScrollView];
    self.songListArrayM = [NSMutableArray array];
    self.songIdsArrayM = [NSMutableArray array];
    [self loadSongList];
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
    self.scrollView.contentSize = CGSizeMake(0, HCScreenHeight + HCScreenWidth * 0.5);
    
    self.headView = [[MYPublicHeadView alloc] initWithFullHead:arc4random() % 2];
    self.headView.frame = CGRectMake(0, 40, HCScreenWidth, HCScreenWidth * 0.5 + 60);
    [self.scrollView addSubview:self.headView];
    
    self.tableView = [[MYPublicTableView alloc] init];
    
    //回调block块（收藏按钮）
    __weak typeof(self) weakSelf = self;
    [self.tableView setShoucang:^(NSInteger ind){
    
    [MYPromptTool promptModeText:@"已收藏" afterDelay:1];
        MYPublicSongDetailModel *musicModel = [[MYPublicSongDetailModel alloc] init];

       musicModel.song_id = weakSelf.responseObject[@"songlist"][ind][@"song_id"];
       musicModel.title = weakSelf.responseObject[@"songlist"][ind][@"title"];
       musicModel.pic_small = weakSelf.responseObject[@"songlist"][ind][@"pic_small"];
        
       [[SQLHandler shareInstance] insert:musicModel];
        
    }];
    
    
    self.tableView.frame = CGRectMake(0, HCScreenWidth * 0.5 + 100, HCScreenWidth, HCScreenHeight);
    [self.scrollView addSubview:self.tableView];
}

#pragma mark - loadListData
- (void)loadSongList
{
    [MYNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.album.getAlbumInfo",@"album_id":self.album_id) response:^(id response) {
        MYPublicSonglistModel *songList = [MYPublicSonglistModel mj_objectWithKeyValues:response[@"albumInfo"]];
        
        [self.headView setNewAlbum:songList];
        NSInteger i = 0;
        for (NSDictionary *dict in response[@"songlist"]) {
            MYPublicSongDetailModel *songDetail = [MYPublicSongDetailModel mj_objectWithKeyValues:dict];
            songDetail.num = ++i;
            [self.songListArrayM addObject:songDetail];
            [self.songIdsArrayM addObject:songDetail.song_id];
        }
        [self.tableView setSongList:self.songListArrayM songIds:self.songIdsArrayM];
        self.responseObject = [response copy];
    }];
}

@end
