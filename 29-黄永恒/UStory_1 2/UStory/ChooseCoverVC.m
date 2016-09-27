//
//  ChooseCoverVC.m
//  UStory
//
//  Created by qingyun on 16/8/24.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ChooseCoverVC.h"
#import "SlipTitleView.h"
#import "CreatCompilationVC.h"

#define strId @"covercell"
#define strHeaderId @"covercheader"

@interface ChooseCoverVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,copy)NSArray *arrTitles;
@end

@implementation ChooseCoverVC

- (NSArray *)arrTitles{
    if (!_arrTitles) {
        NSString *strPath = [[NSBundle mainBundle]pathForResource:@"CoverImage" ofType:@"plist"];
        NSArray *arrImage = [NSArray arrayWithContentsOfFile:strPath];
        _arrTitles = arrImage;
    }
    return _arrTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"更换封面"];
    titleView.backgroundColor = randomColor;
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 2;//最小行距
    flowLayout.minimumInteritemSpacing = 2;//最小列间距
    CGFloat width  = (ScreenWidth - 10)/4;
    flowLayout.itemSize = CGSizeMake(width,width);//每个cell尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 2, 10, 2);//section边距,上左下右
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
    
    /** 创建UICollectionView对象 */
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom);
    }];
    
    /** 设置代理、数据源 */
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    /** 注册cell */
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strId];
    
    // 注册一个Header
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:strHeaderId];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arrSec = self.arrTitles[section];
    return arrSec.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:strId forIndexPath:indexPath];
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.arrTitles[indexPath.section][indexPath.row]]] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(cell.contentView);
    }];
    button.userInteractionEnabled = NO;
    return cell;
}

#pragma mark - ▷ 添加头视图 ◁
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSArray *arrTitleName = @[@"亲情",@"爱情",@"旅行",@"工作",@"友情",@"宠物"];
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:strHeaderId forIndexPath:indexPath];
        for (UIView *view in headerView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *labImageName = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 40)];
        labImageName.text = arrTitleName[indexPath.section];
        [headerView addSubview:labImageName];
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    UIImage *coverImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.arrTitles[indexPath.section][indexPath.row]]];
    NSString *coverImageName = [NSString stringWithFormat:@"%@",self.arrTitles[indexPath.section][indexPath.row]];
    if(self.blkCoverImage){
        self.blkCoverImage(coverImageName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
