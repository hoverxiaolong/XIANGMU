//
//  DiaryContentController.m
//  UStory
//
//  Created by 黄永恒 on 16/8/19.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "DiaryContentController.h"
#import "DiaryToolView.h"
#import "DiaryEditController.h"
#import "CompilationChangeVC.h"
#import "CompilationsViewController.h"

@interface DiaryContentController ()<DiaryToolViewDelegate>
{
    __weak UIView *_toolView;
    __weak UIButton *_btnCompilation;
    __weak UILabel *_labTitle;
    __weak UILabel *_labDiary;
    __weak UILabel *_labCom;
    NSInteger indexCount;
}
@property(nonatomic,strong)NSMutableArray *arrDataCom;
@property(nonatomic,strong)NSMutableArray *arrOldCom;
@property(nonatomic,copy)NSString *strTitle;
@end

@implementation DiaryContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.arrOldCom = [[CompilationDb shareInstance]queryWith:self.model.dequalId];
    [self loadDefaultSetting];
}

-(void)loadDefaultSetting{
    indexCount = 1;
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self.view);
    }];
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    /** 单击手势 */
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView)];
    [scrollView addGestureRecognizer:tapGesture];
    
     /** 标题 */
    UILabel *labTitle = [[UILabel alloc]init];
    labTitle.numberOfLines = 0;
    labTitle.textColor = [UIColor blackColor];
    labTitle.font = [UIFont systemFontOfSize:20];
    [scrollView addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(scrollView).offset(10);
        make.trailing.equalTo(scrollView).offset(-10);
        make.top.equalTo(scrollView).offset(20);
        make.height.mas_equalTo(30);
    }];
    _labTitle = labTitle;
    labTitle.text = self.model.dtitle;
   
    /** 故事集标签 */
    UILabel *labCom = [[UILabel alloc]init];
    labCom.font = [UIFont systemFontOfSize:10];
    labCom.textAlignment = NSTextAlignmentCenter;
    labCom.textColor = [UIColor colorWithRed:172/255.0 green:199/255.0 blue:142/255.0 alpha:1];
    [self.view addSubview:labCom];
    [labCom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(labTitle);
        make.top.equalTo(labTitle.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
    labCom.layer.cornerRadius = 7.5;
    labCom.layer.borderWidth = 1;
    labCom.layer.borderColor = [UIColor colorWithRed:172/255.0 green:199/255.0 blue:142/255.0 alpha:1].CGColor;
    _labCom = labCom;
    
    if ([labCom.text isEqualToString:@""]) {
        labCom.alpha = 0;
    }else{
        labCom.alpha = 1;
        CompilationModel *comModel = self.arrOldCom[0];
        labCom.text = comModel.ctitle;
    }
    
    
     /** 时间 */
    UILabel *labTime = [[UILabel alloc]init];
    labTime.font = [UIFont systemFontOfSize:12];
    labTime.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(labTitle);
        make.top.equalTo(labTitle.mas_bottom).offset(40);
    }];
    labTime.text = self.model.dtime;
    
     /** 日记 */
    UILabel *labDiary = [[UILabel alloc]init];
    labDiary.numberOfLines = 0;
    labDiary.font = [UIFont systemFontOfSize:16];
    [scrollView addSubview:labDiary];
    [labDiary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(labTitle);
        make.trailing.equalTo(scrollView).offset(-10);
        make.top.equalTo(labTime.mas_bottom).offset(25);
    }];
    _labDiary = labDiary;
    labDiary.text = self.model.dcontent;
   
     /** 结束符 */
    UILabel *labEnd = [[UILabel alloc]init];
    labEnd.textAlignment = NSTextAlignmentCenter;
    labEnd.text = @"------------- THE END -------------";
    [scrollView addSubview:labEnd];
    [labEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.leading.trailing.equalTo(labDiary);
        make.top.equalTo(labDiary.mas_bottom).offset(50);
        make.bottom.equalTo(scrollView).offset(-45);
    }];
    
     /** 工具栏 */
    DiaryToolView *toolView = [[DiaryToolView alloc]init];
    toolView.frame = CGRectMake(0, ScreenHeight - 45, ScreenWidth, 45);
    toolView.backgroundColor = [UIColor colorWithRed:75/255.0 green:184/255.0 blue:126/255.0 alpha:1];
    [self.view addSubview:toolView];
    _toolView = toolView;
    toolView.delegate = self;
}

#pragma mark - ▷ 跳转对应故事集页面 ◁
- (void)tapBtnCompilation{
    CompilationsViewController *compilationvc = [[CompilationsViewController alloc]init];
    [self.navigationController pushViewController:compilationvc animated:YES];
}

- (void)tapScrollView{
    indexCount ++;
    if (indexCount%2 == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            _toolView.transform = CGAffineTransformTranslate(_toolView.transform, 0, -45);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _toolView.transform = CGAffineTransformTranslate(_toolView.transform, 0, +45);
        }];
    }
}

- (void)didTapToolBtnWithTag:(NSInteger)tag{
    if (tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.blkReload) {
            self.blkReload();
        }
    }if (tag == 11) {
        //编辑日志
        DiaryEditController *editVC = [[DiaryEditController alloc]init];
        editVC.diaryModel = self.model;
        [self.navigationController pushViewController:editVC animated:YES];
    }if (tag == 12) {
        //删除日志
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"删除故事" message:@"故事删除后不能恢复，确定要继续么？" preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[DiaryDb shareInstance]Delete:self.model.dId];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }if (tag == 13) {
        //更改故事集
        CompilationChangeVC *changeVC = [[CompilationChangeVC alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
        changeVC.blkCompilationName = ^(NSString *compilationName,NSString *imageName,NSInteger equalId){
            self.arrDataCom = [[CompilationDb shareInstance]queryWith:equalId];
            CompilationModel *comModel = self.arrDataCom[0];
    
            DiaryModel *diaryModel = [[DiaryModel alloc]init];
            diaryModel.dId = self.model.dId;
            diaryModel.dtitle = self.model.dtitle;
            diaryModel.dcontent = self.model.dcontent;
            diaryModel.dtime = self.model.dtime;
            
            //更改故事集名字、equalId
            diaryModel.dclass = comModel.ctitle;
            diaryModel.dequalId = equalId;
            [[DiaryDb shareInstance]Updata:diaryModel.dId Info:diaryModel];
            _labCom.text = comModel.ctitle;
            _labCom.alpha = 1;
        };
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
