//
//  SearchViewController.m
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchHeadView.h"
#import "DiaryViewCell.h"
#import "DiaryContentController.h"
#import "TipView.h"

#define strId @"diaryCell"

@interface SearchViewController ()<SearchHeadViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak UICollectionView *_collectionView;
}
@property(nonatomic,strong)NSMutableArray *arrContent;
@property(nonatomic,strong)NSMutableArray *arrIndex;
@property(nonatomic,strong)NSMutableArray *arrTitleModel;

@end

@implementation SearchViewController

- (NSMutableArray *)arrIndex{
    if (!_arrIndex) {
        _arrIndex = [NSMutableArray array];
    }
    return _arrIndex;
}

- (NSMutableArray *)arrTitleModel{
    if (!_arrTitleModel) {
        _arrTitleModel = [NSMutableArray array];
    }
    return _arrTitleModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.arrContent = [[DiaryDb shareInstance]Query];
    [self loadDefaultSetting];
}

-(void)loadDefaultSetting{
    SearchHeadView *headView = [[SearchHeadView alloc]init];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(45);
    }];
    headView.searchViewDelegate = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 30;//最小行距
    flowLayout.itemSize = CGSizeMake(ScreenWidth - 60, 150);//每个cell尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 15, 30);//section边距
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    /** 创建UICollectionView对象 */
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(65);
    }];
    _collectionView = collectionView;
    
    /** 设置代理、数据源 */
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    /** 注册cell */
    [collectionView registerClass:[DiaryViewCell class] forCellWithReuseIdentifier:strId];
}


#pragma mark - ▶ DataSource ◀
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrIndex.count;
}

#pragma mark - ▶ Delegate ◀
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DiaryViewCell *diaryCell = [DiaryViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    diaryCell.layer.cornerRadius = 5;
    diaryCell.layer.masksToBounds = YES;
    
    DiaryModel *diaryModel = self.arrIndex[indexPath.row];
    diaryCell.model = diaryModel;
    return diaryCell;
}

#pragma mark - ▶ 点击item事件 ◀
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiaryContentController *diaryContentVC = [[DiaryContentController alloc]init];
    diaryContentVC.model = self.arrIndex[indexPath.row];
    [self.navigationController pushViewController:diaryContentVC animated:YES];
}

#pragma mark - ▷ 搜索关键字 ◁
- (void)didTapSearchBtnWithText:(NSString *)searchText{
    [self.view endEditing:YES];
    self.arrIndex = nil;
    //在日志内容里搜索
    for (DiaryModel *dmodel in self.arrContent) {
        NSString *strDiary = dmodel.dcontent;
        if ([strDiary containsString:searchText]) {
            [self.arrIndex addObject:dmodel];
        }else{
            [self.arrTitleModel addObject:dmodel];
            //在日志标题中搜索
            for (DiaryModel *tmodel in self.arrTitleModel) {
                NSString *strTitle = tmodel.dtitle;
                if ([strTitle containsString:searchText]) {
                    [self.arrIndex addObject:tmodel];
                }
            }
        }
    }
    [_collectionView reloadData];
    if (self.arrIndex.count == 0) {
        TipView *tip = [[TipView alloc]initWithFrame:CGRectMake((ScreenWidth - 150)/2, 150, 150, 30) Title:@"暂无搜索结果" Time:1.5];
        [self.view addSubview:tip];
        NSLog(@"无搜索结果");
    }
}

- (void)didTapBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
