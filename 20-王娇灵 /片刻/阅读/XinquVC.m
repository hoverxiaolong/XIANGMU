//
//  XinquVC.m
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "XinquVC.h"
#import "MYPublicCollectionCellCollectionViewCell.h"
#import "MYPublicMusicTabelModel.h"
#import "XinquListVC.h"
#import "MYNetWorkTool.h"
#import "NSObject+MJKeyValue.h"
#import "JXLDayAndNightMode.h"

/*-----screenSize-----*/
#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCScreenHeight HCScreen.size.height

/*-----nslog-----*/

#ifdef DEBUG

#define HCLog(...) NSLog(__VA_ARGS__)

#else

#define HCLog(...)

#endif

#define HCUrl @"http://tingapi.ting.baidu.com/v1/restserver/ting"

#define HCParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}
#define HCMusic @"http://ting.baidu.com/data/music/links"
@interface XinquVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong) NSMutableArray *SongAlbumArrayM;
@property (nonatomic ,strong) UICollectionView *songAlbumCollectionView;

@end

@implementation XinquVC
static NSString *reuseId = @"newSong";
- (NSMutableArray *)SongAlbumArrayM
{
    if (!_SongAlbumArrayM) {
        _SongAlbumArrayM = [NSMutableArray array];
        [self loadNewSongData];
    }
    return _SongAlbumArrayM;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.songAlbumCollectionView.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self config];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.songAlbumCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.songAlbumCollectionView registerClass:[MYPublicCollectionCellCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    self.songAlbumCollectionView.delegate = self;
    self.songAlbumCollectionView.dataSource = self;
    [self.view addSubview:self.songAlbumCollectionView];
}

- (void)config {
    [self.view jxl_setDayMode:^(UIView *view) {
        
        self.songAlbumCollectionView.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        
        self.songAlbumCollectionView.backgroundColor = [UIColor blackColor];
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

#pragma mark - collectionViewDelegate代理😳
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.SongAlbumArrayM.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYPublicMusicTabelModel *musicTable = self.SongAlbumArrayM[indexPath.row];
    MYPublicCollectionCellCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    [collectionCell setNewSongAlbum:musicTable];
    return collectionCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MYPublicMusicTabelModel *tables = self.SongAlbumArrayM[indexPath.row];
    //HCLog(@"---%@",tables.album_id);
    XinquListVC *listView = [[XinquListVC alloc] init];
    listView.album_id = tables.album_id;
    listView.pic = tables.pic_big;
    [self.navigationController pushViewController:listView animated:YES];
}
#pragma mark - layout布局
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = (HCScreenWidth - 10) / 2;
   // HCLog(@"%ld",(long)width);
    CGSize size = CGSizeMake(width, width + 40);
    return size;
}
#pragma mark - load data加载数据
- (void)loadNewSongData
{
    [MYNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.plaza.getRecommendAlbum",@"offset":@0,@"limit":@50,@"type":@2) response:^(id response) {
        if (response) {
            for (NSDictionary *dict in response[@"plaze_album_list"][@"RM"][@"album_list"][@"list"]) {
                MYPublicMusicTabelModel *table = [MYPublicMusicTabelModel mj_objectWithKeyValues:dict];
                [self.SongAlbumArrayM addObject:table];
            }
            [self.songAlbumCollectionView reloadData];
        }else{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"music"ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:path];
            
            for (NSDictionary *dict in array) {
                MYPublicMusicTabelModel *table = [MYPublicMusicTabelModel mj_objectWithKeyValues:dict];
                [self.SongAlbumArrayM addObject:table];
            }
            [self.songAlbumCollectionView reloadData];
        }
        
        
    }];
}

@end
