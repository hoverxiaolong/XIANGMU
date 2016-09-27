//
//  CompilationsViewController.m
//  UStory
//
//  Created by 黄永恒 on 16/8/19.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CompilationsViewController.h"
#import "DiaryViewCell.h"
#import "WhiteTitleView.h"
#import "DiaryContentController.h"
#import "CompilationEditVC.h"

#define strId @"diaryCell"
#define strHeaderId @"headerimage"

@interface CompilationsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
     UIImageView *_headerImage;
     WhiteTitleView *_titleView;
}
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,weak)UIView *optionView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *arrDataDiary;
@end

@implementation CompilationsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self viewDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.arrDataDiary = [[DiaryDb shareInstance]queryWith:self.model.cId];
    [self loadDefaultSetting];
}

-(void)loadDefaultSetting{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 30;//最小行距
    flowLayout.itemSize = CGSizeMake(ScreenWidth - 60, 150);//每个cell尺寸
    flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 15, 30);//section边距
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, ScreenWidth * 0.6);
    
    /** 创建UICollectionView对象 */
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
    
    /** 设置代理、数据源 */
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    /** 注册cell */
    [collectionView registerClass:[DiaryViewCell class] forCellWithReuseIdentifier:strId];
    
    // 注册一个Header
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:strHeaderId];
    
    UIView *bgTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40)];
    bgTitleView.backgroundColor = [UIColor blackColor];
    bgTitleView.alpha = 0.2;
    [self.view addSubview:bgTitleView];
    
    __weak typeof(self) selfWeak = self;
    
    WhiteTitleView *titleView = [[WhiteTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:self.model.ctitle];
    titleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    _titleView = titleView;
    
    /** 选项按钮 */
    UIButton *btnOption = [[UIButton alloc]init];
    [btnOption setImage:[UIImage imageNamed:@"whiteoption"] forState:UIControlStateNormal];
    [titleView addSubview:btnOption];
    [btnOption mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(titleView).offset(-15);
        make.top.equalTo(titleView).offset(10);
        make.bottom.equalTo(titleView).offset(-10);
        make.width.equalTo(@(20));
    }];
    [btnOption addTarget:self action:@selector(didTapOptionBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.index = 0;
    UIView *optionView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 35, 30, 20, 20)];
    optionView.backgroundColor = [UIColor whiteColor];
    optionView.alpha = 0;
    [self.view addSubview:optionView];
    optionView.layer.cornerRadius = 10;
    optionView.layer.masksToBounds = YES;
    self.optionView = optionView;
    
    /** 编辑专辑 */
    UIButton *editBtn = [[UIButton alloc]init];
    [editBtn setTitle:@"  编辑故事集" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [optionView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(optionView).offset(5);
        make.trailing.equalTo(optionView).offset(-5);
//        make.height.mas_equalTo(30);
    }];
    [editBtn addTarget:self action:@selector(didTapEditBtn) forControlEvents:UIControlEventTouchUpInside];
    
    /** 删除专辑 */
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn setTitle:@"  删除故事集" forState:UIControlStateNormal];
    [optionView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(editBtn);
        make.top.equalTo(editBtn.mas_bottom).offset(3);
        make.bottom.equalTo(optionView).offset(-7);
    }];
    [deleteBtn addTarget:self action:@selector(didTapDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - ▶ DataSource ◀
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrDataDiary.count;
}

#pragma mark - ▶ Delegate ◀
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DiaryViewCell *diaryCell = [DiaryViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    diaryCell.layer.cornerRadius = 5;
    diaryCell.layer.masksToBounds = YES;
    
    DiaryModel *model = self.arrDataDiary[indexPath.row];
    diaryCell.model = model;
    return diaryCell;
}

#pragma mark - ▷ 添加头视图 ◁
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:strHeaderId forIndexPath:indexPath];
        
        UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 0.6)];
        headerImage.contentMode = UIViewContentModeScaleToFill;
        headerImage.image = [UIImage imageNamed:self.model.coverImage];
        [headerView addSubview:headerImage];
        headerView.clipsToBounds = YES;
        _headerImage = headerImage;
        
        /** 故事集描述 */
        UILabel *labDescribe = [[UILabel alloc]init];
        labDescribe.backgroundColor = [UIColor clearColor];
        //    labDescribe.alpha = 0.5;
        labDescribe.textColor = [UIColor colorWithRed:239/255.0 green:91/255.0 blue:47/255.0 alpha:1];
        labDescribe.font = [UIFont systemFontOfSize:12];
        labDescribe.numberOfLines = 0;
        [headerImage addSubview:labDescribe];
        [labDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view).offset(10);
            make.trailing.equalTo(self.view).offset(-10);
            make.bottom.equalTo(headerImage);
            make.height.mas_equalTo(50);
        }];
        labDescribe.text = self.model.cdescribe;
        [self.view bringSubviewToFront:labDescribe];
        return headerView;
    }
    return nil;
}

#pragma mark - ▶ 点击item事件 ◀
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiaryContentController *diaryVC = [[DiaryContentController alloc]init];
    diaryVC.model = self.arrDataDiary[indexPath.row];
    [self.navigationController pushViewController:diaryVC animated:YES];
    diaryVC.blkReload = ^{
        [collectionView reloadData];
    };
}

#pragma mark - ▷ 点击编辑按钮 ◁
- (void)didTapOptionBtn{
    self.index ++;
    if (self.index%2 == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.optionView.alpha = 1;
            self.optionView.frame = CGRectMake(ScreenWidth - 130, 70, 120, 70);
        }];
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            self.optionView.alpha = 0;
            self.optionView.frame = CGRectMake(ScreenWidth - 35, 30, 20, 20);
        }];
    }
}

#pragma mark - ▷ 编辑故事集 ◁
- (void)didTapEditBtn{
    CompilationEditVC *editVC = [[CompilationEditVC alloc]init];
    editVC.model = self.model;
    [self.navigationController pushViewController:editVC animated:YES];
    editVC.blkEditCompilation = ^(NSString *strComTitle,NSString *strComImage,NSString *srtComDes){
        _titleView.labTitle.text = strComTitle;
        _headerImage.image = [UIImage imageNamed:strComImage];
    };
    self.index ++;
    self.optionView.alpha = 0;
    self.optionView.frame = CGRectMake(ScreenWidth - 35, 30, 20, 20);
}

#pragma mark - ▷ 删除故事集 ◁
- (void)didTapDeleteBtn{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"删除故事集" message:@"确定要删除该故事集吗？\n删除故事集不会删除里面的故事内容" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CompilationDb shareInstance]Delete:self.model.cId];
        
        //删除故事集后，把日志的id变为0,然后保存
        for (DiaryModel *model in self.arrDataDiary) {
            model.dequalId = 0;
            model.dId = model.dId;
            model.dtitle = model.dtitle;
            model.dcontent = model.dcontent;
            model.dclass = @"";
            model.dtime = model.dtime;
            [[DiaryDb shareInstance]Updata:model.dId Info:model];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
