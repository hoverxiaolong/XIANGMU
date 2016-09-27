//
//  MainDiaryView.m
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "MainDiaryView.h"
#import "DiaryViewCell.h"
#import "DiaryDb.h"
#import "DiaryModel.h"


#define strId @"diaryCell"

@interface MainDiaryView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak UIView *_panView;
}
@property(nonatomic,strong)NSMutableArray *dataDiary;
@end

@implementation MainDiaryView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
    
    self.dataDiary = [[DiaryDb shareInstance]Query];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 30;//最小行距
    flowLayout.itemSize = CGSizeMake(ScreenWidth - 60, 150);//每个cell尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 15, 30);//section边距
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    /** 创建UICollectionView对象 */
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self);
    }];
    
    /** 设置代理、数据源 */
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    /** 注册cell */
    [collectionView registerClass:[DiaryViewCell class] forCellWithReuseIdentifier:strId];
    
    UIView *panView = [[UIView alloc]init];
    [self addSubview:panView];
    [panView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.width.mas_equalTo(30);
    }];
    _panView = panView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [panView addGestureRecognizer:pan];
}

#pragma mark - ▶ DataSource ◀
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrDiaryModel.count;
}

#pragma mark - ▶ Delegate ◀
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DiaryViewCell *diaryCell = [DiaryViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    diaryCell.layer.cornerRadius = 5;
    diaryCell.layer.masksToBounds = YES;
    
    DiaryModel *diaryModel = self.arrDiaryModel[[self.arrDiaryModel count] - indexPath.row - 1];
    diaryCell.model = diaryModel;
    return diaryCell;
}

#pragma mark - ▶ 点击item事件 ◀
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.diaryDelegate respondsToSelector:@selector(didSelectDiaryItemAtIndexPath:)]) {
        [self.diaryDelegate didSelectDiaryItemAtIndexPath:indexPath];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:_panView];
    if (point.x > 0) {
//        if ([self.diaryDelegate respondsToSelector:@selector(pan)]) {
//            [self.diaryDelegate pan];
//        }
        [self.diaryDelegate pan];
    }
}

@end
