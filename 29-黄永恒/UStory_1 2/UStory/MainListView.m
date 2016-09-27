//
//  MainListView.m
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "MainListView.h"
#import "ListCollectionCell.h"
#import "CompilationDb.h"
#import "CompilationModel.h"

#define strId @"collectionCell"
#define strHeaderId @"listheader"

@interface MainListView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UIButton *headerBtn;
@property(nonatomic,strong)NSMutableArray *dataCompilation;
@end
@implementation MainListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
    
    self.dataCompilation = [[CompilationDb shareInstance]Query];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = (ScreenWidth - 60)/2;
    flowLayout.minimumLineSpacing = 15;//最小行距
    flowLayout.minimumInteritemSpacing = 10;//最小列间距
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth/0.8 + 30 + 15);//每个cell尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 15, 20);//section边距
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 44);
    flowLayout.sectionHeadersPinToVisibleBounds = NO;//固定header
    
     /** 创建UICollectionView对象 */
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self);
    }];
    
    /** 设置代理、数据源 */
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
     /** 注册cell */
    [collectionView registerClass:[ListCollectionCell class] forCellWithReuseIdentifier:strId];
    
    // 注册一个Header
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:strHeaderId];
    
}

#pragma mark - ▶ DataSource ◀
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataCompilation.count;
}

#pragma mark - ▶ Delegate ◀
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ListCollectionCell *listCell = [ListCollectionCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    CompilationModel *model = self.dataCompilation[indexPath.row];
    listCell.compilationModel = model;
    
    return listCell;
}

#pragma mark - ▷ 添加头视图 ◁
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:strHeaderId forIndexPath:indexPath];
 
        UIButton *headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        [headerBtn setTitle:@"  创建故事集" forState:UIControlStateNormal];
        [headerBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.headerBtn = headerBtn;
        [headerView addSubview:self.headerBtn];
        [headerBtn addTarget:self action:@selector(didTapCreatCompilationBtn) forControlEvents:UIControlEventTouchUpInside];
        return headerView;
    }
    return nil;
}

#pragma mark - ▶ 点击item事件 ◀
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionDelegate respondsToSelector:@selector(didSelectListItemAtIndexPath:)]) {
        [self.collectionDelegate didSelectListItemAtIndexPath:indexPath];
    }
}

- (void)didTapCreatCompilationBtn{
    if ([self.collectionDelegate respondsToSelector:@selector(didTapCreatCompilationBtn)]) {
        [self.collectionDelegate didTapCreatCompilationBtn];
    }
}


@end
