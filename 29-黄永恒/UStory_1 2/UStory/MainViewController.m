//
//  ViewController.m
//  UStory
//
//  Created by 黄永恒 on 16/8/15.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "MainViewController.h"
#import "MainHeadView.h"
#import "MainDiaryView.h"
#import "MainListView.h"
#import "SearchViewController.h"
#import "CompilationsViewController.h"
#import "ControVC.h"
#import "CreatCompilationVC.h"
#import "WriteNewDiaryVC.h"
#import "DiaryContentController.h"

@interface MainViewController ()<UIScrollViewDelegate,MainHeadViewDelegate,MainListViewDelegate,MainDiaryViewDelegate>
{
    __weak UIScrollView *_scrollView;
    __weak MainHeadView *_mainHeadView;
    __weak UIButton *_writeDiaryBtn;
    NSUInteger _indexCurrent;
}
@property(nonatomic,strong)NSMutableArray *arrDataDiary;
@property(nonatomic,strong)NSMutableArray *arrDataCompilation;
@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrDataDiary = [[DiaryDb shareInstance]Query];
    self.arrDataCompilation = [[CompilationDb shareInstance]Query];
    [self loadDefaultSetting];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
     /** 表头视图 */
    MainHeadView *mainHeadView = [[MainHeadView alloc]init];
    mainHeadView.backgroundColor = [UIColor colorWithRed:75/255.0 green:184/255.0 blue:126/255.0 alpha:1];
    [self.view addSubview:mainHeadView];
    [mainHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(45);
    }];
    [mainHeadView setBlkDidChooseBtnAtIndex:^(NSUInteger index) {
        [selfWeak scrollViewChangeAction:index];
    }];
    mainHeadView.headViewDelegate = self;
    _mainHeadView = mainHeadView;
    
     /** 滚动页面 */
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(2 * ScreenWidth, ScreenHeight - 65)];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(mainHeadView.mas_bottom);
        
    }];
    _scrollView = scrollView;
    
    UIView *view = [UIView new];
    [scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(scrollView);
        make.leading.top.bottom.trailing.equalTo(scrollView);
        make.width.equalTo(scrollView).multipliedBy(2);
    }];
    
    MainDiaryView *diaryView = [[MainDiaryView alloc]init];
    [view addSubview:diaryView];
    diaryView.diaryDelegate = self;
    diaryView.arrDiaryModel = self.arrDataDiary;
    [diaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(view);
        make.top.bottom.equalTo(view);
        make.width.mas_equalTo(scrollView);
    }];
    
    MainListView *listView = [[MainListView alloc]init];
    [view addSubview:listView];
    listView.collectionDelegate = self;
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(diaryView.mas_trailing);
        make.top.bottom.trailing.equalTo(view);
        make.width.mas_equalTo(scrollView);
    }];
    
    /** 背景View */
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    _bgView.frame = CGRectMake(0, 65, ScreenWidth, ScreenHeight);
    _bgView.alpha = 0;
    
    /** 写故事 */
    UIButton *writeDiaryBtn = [[UIButton alloc]init];
    writeDiaryBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green:184/255.0 blue:126/255.0 alpha:1];
    [writeDiaryBtn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    [self.view addSubview:writeDiaryBtn];
    [writeDiaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(60);
    }];
    _writeDiaryBtn = writeDiaryBtn;
    writeDiaryBtn.layer.cornerRadius = 30;
    writeDiaryBtn.layer.masksToBounds = YES;
    [writeDiaryBtn addTarget:self action:@selector(tapWriteNewDiaryBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - ▶ 滚动页面随选项滑动 ◀
- (void)scrollViewChangeAction:(NSUInteger)index{
    [_scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0)];
}

#pragma mark - ▶ 滚动页面滑动结束 ◀
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        _indexCurrent = scrollView.contentOffset.x/scrollView.bounds.size.width;
        [_mainHeadView chooseIndex:_indexCurrent];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alpha = scrollView.contentOffset.x/scrollView.bounds.size.width;
    _writeDiaryBtn.alpha = 1-alpha;
}

#pragma mark - ▷ 跳转侧滑栏按钮 ◁
- (void)didTapSideslipBtn{
    ControVC *controVC = (ControVC *)self.parentViewController;
    [controVC didTapSideslipHomeBtn];
}

#pragma mark - ▷ 点击搜索按钮 ◁
- (void)didTapSearchBtn{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - ▷ 点击diaryView跳转页面 ◁
- (void)didSelectDiaryItemAtIndexPath:(NSIndexPath *)indexPath{
    DiaryContentController *diaryContentVC = [[DiaryContentController alloc]init];
    diaryContentVC.model = self.arrDataDiary[[self.arrDataDiary count] - indexPath.row - 1];
    [self.navigationController pushViewController:diaryContentVC animated:YES];
}

#pragma mark - ▷ 点击listView跳转页面 ◁
- (void)didSelectListItemAtIndexPath:(NSIndexPath *)indexPath{
    CompilationsViewController *compilationsVC = [[CompilationsViewController alloc]init];
    compilationsVC.model = self.arrDataCompilation[indexPath.row];
    [self.navigationController pushViewController:compilationsVC animated:YES];
}

#pragma mark - ▷ 写日记 ◁
- (void)tapWriteNewDiaryBtn{
    WriteNewDiaryVC *newdiaryVC = [[WriteNewDiaryVC alloc]init];
    [self.navigationController pushViewController:newdiaryVC animated:YES];
}

#pragma mark - ▷ 创建新故事集 ◁
- (void)didTapCreatCompilationBtn{
    CreatCompilationVC *creatCompilationVC = [[CreatCompilationVC alloc]init];
    [self.navigationController pushViewController:creatCompilationVC animated:YES];
}

- (void)pan{
    ControVC *controVC = (ControVC *)self.parentViewController;
    [controVC didTapSideslipHomeBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
