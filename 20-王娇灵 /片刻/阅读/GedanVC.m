//
//  GedanVC.m
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "GedanVC.h"
#import "MYPublicMusicTabelModel.h"
#import "MYPublicCollectionCellCollectionViewCell.h"
#import "GedanList.h"
#import "UIScrollView+MJRefresh.h"

#import "MJRefresh.h"

#import "MYNetWorkTool.h"
#import "NSObject+MJKeyValue.h"


#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCUrl @"http://tingapi.ting.baidu.com/v1/restserver/ting"
#define HCParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}
/*-----nslog-----*/

#ifdef DEBUG

#define HCLog(...) NSLog(__VA_ARGS__)

#else

#define HCLog(...)

#endif


static NSString *strID = @"songMenu";

@interface GedanVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *gedanMenuArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger menuPage;

@end

@implementation GedanVC


#pragma mark - 懒加载

- (NSMutableArray *)gedanMenuArray {
    
    if (!_gedanMenuArray) {
        
        _gedanMenuArray = [NSMutableArray array];
        self.menuPage = 1;
         [self loadSongMenuWithPage:self.menuPage array:self.gedanMenuArray reloadView:self.collectionView];
    }
    return _gedanMenuArray;
}

#pragma mark - viewAppear - > viewLoad
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"歌单";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpSongMenuCollectionView];
    [self setUpRefreshFooter];
}
#pragma mark - setUpCollectionView
- (void)setUpSongMenuCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[MYPublicCollectionCellCollectionViewCell class] forCellWithReuseIdentifier:strID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}
- (void)setUpRefreshFooter
{
    __weak __typeof(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.menuPage += 1;
        [self loadSongMenuWithPage:self.menuPage array:weakSelf.gedanMenuArray reloadView:weakSelf.collectionView];
        self.collectionView.mj_footer.hidden = YES;
    }];
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.mj_footer.hidden = self.gedanMenuArray.count == 0;
    return self.gedanMenuArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYPublicMusicTabelModel *musicTable = self.gedanMenuArray[indexPath.row];
    MYPublicCollectionCellCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:strID forIndexPath:indexPath];
    [collectionCell setSongMenu:musicTable];
    return collectionCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MYPublicMusicTabelModel*tables = self.gedanMenuArray[indexPath.row];
    //HCLog(@"---%@",tables.listid);
    GedanList *listView = [[GedanList alloc] init];
    listView.listid = tables.listid;
    listView.pic = tables.pic_300;
    [self.navigationController pushViewController:listView animated:YES];
}
#pragma mark - layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = (HCScreenWidth - 10) / 2;
    //HCLog(@"%ld",(long)width);
    CGSize size = CGSizeMake(width, width + 40);
    return size;
}
#pragma mark - loadData
- (void)loadSongMenuWithPage:(NSInteger)page array:(NSMutableArray *)array reloadView:(UICollectionView *)view
{
    [MYNetWorkTool netWorkToolGetWithUrl:HCUrl parameters:HCParams(@"method":@"baidu.ting.diy.gedan",@"page_no":[NSString stringWithFormat:@"%ld",(long)page],@"page_size":@"30") response:^(id response) {
        for (NSDictionary *dict in response[@"content"]) {
            MYPublicMusicTabelModel *tables = [MYPublicMusicTabelModel mj_objectWithKeyValues:dict];
            [array addObject:tables];
            [view reloadData];
        }
    }];
}


@end
