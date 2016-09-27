//
//  WriteNewDiaryVC.m
//  UStory
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "WriteNewDiaryVC.h"
#import "NewDiaryHeaderView.h"
#import "CompilationChangeVC.h"

@interface WriteNewDiaryVC ()<NewDiaryViewDelegate>
{
    __weak UIView *_addView;
    __weak UITextField *_textTitle;
    __weak UITextView *_textDiary;
    __weak UIImageView *_comImage;
    __weak UILabel *_labCom;
    __weak UIButton *_btnBoard;
}
@property(nonatomic,copy)NSString *strName;
@property(nonatomic,assign)NSInteger equalId;
@property(nonatomic,strong)NSMutableArray *arrDataCom;
@end

@implementation WriteNewDiaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    
    NewDiaryHeaderView *headerView = [[NewDiaryHeaderView alloc]init];
    headerView.backgroundColor = [UIColor colorWithRed:75/255.0 green:184/255.0 blue:126/255.0 alpha:1];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(40);
    }];
    headerView.delegate = self;
    [headerView setBlkCancelBtn:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    /** 日志标题 */
    UITextField *textTitle = [[UITextField alloc]init];
    textTitle.placeholder = @"标  题";
    [self.view addSubview:textTitle];
    [textTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.top.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    _textTitle = textTitle;
    
    /** 底部视图 */
    UIView *addView = [[UIView alloc]init];
    addView.backgroundColor = [UIColor colorWithRed:206/255.0 green:229/255.0 blue:200/255.0 alpha:1];
    [self.view addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    _addView = addView;
    
    /** 日志内容 */
    UITextView *textDiary = [[UITextView alloc]init];
    textDiary.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textDiary];
    [textDiary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(textTitle);
        make.top.equalTo(textTitle.mas_bottom);
        make.bottom.equalTo(addView.mas_top);
    }];
    _textDiary = textDiary;
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"在这里写下您的故事吧...";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [textDiary setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    [textDiary addSubview:placeHolderLabel];
    
    /** 故事集图片 */
    UIImageView *comImage = [[UIImageView alloc]init];
    comImage.image = [UIImage imageNamed:@"image"];
    comImage.contentMode = UIViewContentModeScaleToFill;
    [addView addSubview:comImage];
    [comImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(addView).offset(8);
        make.top.equalTo(addView).offset(4);
        make.bottom.equalTo(addView).offset(-4);
        make.width.mas_equalTo(36);
    }];
    _comImage = comImage;
    addView.clipsToBounds = YES;
    
    /** 故事集名字 */
    UILabel *labCom = [[UILabel alloc]init];
    labCom.font = [UIFont systemFontOfSize:16];
    labCom.textAlignment = NSTextAlignmentLeft;
    labCom.textColor = [UIColor colorWithRed:243/255.0 green:130/255.0 blue:49/255.0 alpha:1];
    labCom.text = @"添加至故事集";
    [addView addSubview:labCom];
    [labCom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(addView);
        make.leading.equalTo(comImage.mas_trailing).offset(8);
        make.width.mas_equalTo(200);
    }];
    _labCom = labCom;
    
    /** 键盘按钮 */
    UIButton *btnBoard = [[UIButton alloc]init];
    [btnBoard setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [addView addSubview:btnBoard];
    [btnBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(_addView);
        make.width.mas_equalTo(44);
    }];
    [btnBoard addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    _btnBoard = btnBoard;

    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addToCompilation)];
    [addView addGestureRecognizer:tap];
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - ▷ 添加至故事集 ◁
- (void)addToCompilation{
    CompilationChangeVC *compilationChangeVC = [[CompilationChangeVC alloc]init];
    [self.navigationController pushViewController:compilationChangeVC animated:YES];
    compilationChangeVC.blkCompilationName = ^(NSString *compilationName,NSString *imageName,NSInteger equalId){
        _comImage.image = [UIImage imageNamed:imageName];
        _labCom.text = compilationName;
        self.strName = compilationName;
        self.equalId = equalId;
    };
}

#pragma mark - ▷ 保存日记 ◁
- (void)SaveNewDiary{
    //以时间作为主键id
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *formatString = @"yy-MM-dd";
    formatter.dateFormat = formatString;
    NSString *strTime = [formatter stringFromDate:date];
    NSTimeInterval time = [date timeIntervalSince1970];
    
    DiaryModel *diaryModel = [[DiaryModel alloc]init];
    diaryModel.dId = time;
    diaryModel.dtitle = _textTitle.text;
    diaryModel.dcontent = _textDiary.text;
    diaryModel.dtime = strTime;
    if (self.equalId == 0) {
        diaryModel.dequalId = 0;
        diaryModel.dclass = nil;
    }else{
        self.arrDataCom = [[CompilationDb shareInstance]queryWith:self.equalId];
        CompilationModel *comModel = self.arrDataCom[0];
        diaryModel.dequalId = self.equalId;
        diaryModel.dclass = comModel.ctitle;
    }
    
    [[DiaryDb shareInstance]Insert:diaryModel];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ▷ 键盘即将出现 ◁
-(void)keyboardWillShow:(NSNotification *)noti{
    //根据通知的info,找到键盘显示的最终位置,显示过程中的动画时长
    NSValue *boardsEnd = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = boardsEnd.CGRectValue;
    CGFloat animation = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animation animations:^{
        [_addView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-endFrame.size.height);
        }];
        
        [_btnBoard setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ▷ 键盘即将消失 ◁
-(void)keyboardWillHide:(NSNotification *)noti{
    //根据动画事件,调整底部的约束
    CGFloat animation = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animation animations:^{
        [_addView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        [_btnBoard setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ▷ 结束编辑 ◁
- (void)hideKeyBoard{
        [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
