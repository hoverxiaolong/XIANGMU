//
//  DiaryEditController.m
//  UStory
//
//  Created by 黄永恒 on 16/8/22.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "DiaryEditController.h"

@interface DiaryEditController ()<UITextFieldDelegate>
{
    __weak UITextField *_textTitle;
    __weak UITextView *_textDiary;
}
@end

@implementation DiaryEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

-(void)loadDefaultSetting{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:75/255.0 green:184/255.0 blue:126/255.0 alpha:1];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(40);
    }];
    
     /** 取消按钮 */
    UIButton *btnCancle = [[UIButton alloc]init];
    [btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    btnCancle.titleLabel.textColor = [UIColor blackColor];
    btnCancle.tag = 10086;
    [view addSubview:btnCancle];
    [btnCancle addTarget:self action:@selector(tapBtnChose:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(view).offset(10);
        make.top.equalTo(view).offset(5);
        make.bottom.equalTo(view).offset(-5);
    }];
    
     /** 确认按钮 */
    UIButton *btnCertain = [[UIButton alloc]init];
    [btnCertain setTitle:@"确定" forState:UIControlStateNormal];
    btnCertain.titleLabel.textColor = [UIColor blackColor];
    btnCertain.tag = 10010;
    [view addSubview:btnCertain];
    [btnCertain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(view).offset(-10);
        make.top.bottom.equalTo(btnCancle);
    }];
    [btnCertain addTarget:self action:@selector(tapBtnChose:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 时间 */
    UILabel *labTime = [[UILabel alloc]init];
    labTime.textAlignment = NSTextAlignmentCenter;
    labTime.font = [UIFont systemFontOfSize:15];
    labTime.text = self.diaryModel.dtime;
    [view addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(view);
        make.width.mas_equalTo(150);
    }];
    
    /** 标题 */
    UITextField *textTitle = [[UITextField alloc]init];
    textTitle.placeholder = @" 标  题";
    textTitle.text = self.diaryModel.dtitle;
    textTitle.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:textTitle];
    [textTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(8);
        make.trailing.equalTo(self.view).offset(-8);
        make.top.equalTo(view.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    _textTitle = textTitle;
    
    UIView *cutView = [[UIView alloc]init];
    cutView.backgroundColor = [UIColor lightGrayColor];
    cutView.alpha = 0.6;
    [self.view addSubview:cutView];
    [cutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(textTitle.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    /** 日志 */
    UITextView *textDiary = [[UITextView alloc]init];
    textDiary.font = [UIFont systemFontOfSize:16];
    textDiary.text = self.diaryModel.dcontent;
    [self.view addSubview:textDiary];
    [textDiary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(textTitle);
        make.top.equalTo(cutView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    _textDiary = textDiary;

    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapBtnChose:(UIButton *)button{
    if (button.tag == 10086) {
    }else{
        //保存编辑
        DiaryModel *model = [[DiaryModel alloc]init];
        model.dId = self.diaryModel.dId;
        model.dtitle = _textTitle.text;
        model.dcontent = _textDiary.text;
        model.dclass = self.diaryModel.dclass;
        model.dtime = self.diaryModel.dtime;
        model.dequalId = self.diaryModel.dequalId;
        [[DiaryDb shareInstance]Updata:model.dId Info:model];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ▷ 键盘即将出现 ◁
-(void)keyboardWillShow:(NSNotification *)noti{
    //根据通知的info,找到键盘显示的最终位置,显示过程中的动画时长
    NSValue *boardsEnd = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = boardsEnd.CGRectValue;
    CGFloat animation = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animation animations:^{
        [_textDiary mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-endFrame.size.height);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ▷ 键盘即将消失 ◁
-(void)keyboardWillHide:(NSNotification *)noti{
    //根据动画事件,调整底部的约束
    CGFloat animation = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animation animations:^{
        [_textDiary mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
