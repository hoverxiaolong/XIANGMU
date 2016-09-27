//
//  ForgetPWViewController.m
//  UStory
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "SlipTitleView.h"
#import "ResetPWViewController.h"
#import "TipView.h"
#import "CheckPhoneVC.h"

@interface ForgetPWViewController ()
{
    __weak UITextField *_textField;
    __weak UILabel *_labTip;
}
@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"忘记密码"];
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"请输入您已经绑定的手机号码";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(25);
        make.top.equalTo(titleView.mas_bottom).offset(15);
        make.trailing.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(30);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    textField.placeholder = @"请输入手机号码";
    textField.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
    _textField = textField;
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = [UIColor cyanColor];
    [button setTitle:@"确\t定" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(label);
        make.top.equalTo(textField.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(didTapButton) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *bindBtn = [[UIButton alloc]init];
//    bindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [bindBtn setTitle:@"去验证>>" forState:UIControlStateNormal];
//    [bindBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [self.view addSubview:bindBtn];
//    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(button);
//        make.top.equalTo(button.mas_bottom).offset(15);
//        make.height.mas_equalTo(20);
//    }];
//    [bindBtn addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapButton{
    if (_textField.text.length == 11) {
        [AVUser requestPasswordResetWithPhoneNumber:_textField.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                ResetPWViewController *resetVC = [[ResetPWViewController alloc]init];
                resetVC.strPhoneNum = _textField.text;
                [self.navigationController pushViewController:resetVC animated:YES];
            } else {
                TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, ScreenHeight - 300, 150, 50) Title:@"请确认手机号是否已经注册绑定" Time:2];
                [self.view addSubview:tipView];
            }
        }];
    }else{
        UILabel *labTip = [[UILabel alloc]init];
        labTip.backgroundColor = [UIColor lightGrayColor];
        labTip.textColor = [UIColor whiteColor];
        labTip.textAlignment = NSTextAlignmentCenter;
        labTip.text = @"请输入已绑定手机号";
        labTip.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:labTip];
        [labTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-100);
            make.width.mas_equalTo(200);
        }];
        _labTip = labTip;
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(tipMiss) userInfo:nil repeats:NO];
        
    }
}

- (void)bindPhone{
    if (_textField.text.length != 11) {
        TipView *tip = [[TipView alloc]initWithFrame:CGRectMake((ScreenWidth - 100)/2, ScreenHeight - 250, 100, 30) Title:@"请输入手机号" Time:1.5];
        [self.view addSubview:tip];
    }else{
        [AVUser requestMobilePhoneVerify:_textField.text withBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 330, 100, 30) Title:@"发送成功" Time:1];
                tipView.blkTipView = ^{
                    CheckPhoneVC *checkVC = [[CheckPhoneVC alloc]init];
                    checkVC.strPhoneNum = _textField.text;
                    [self.navigationController pushViewController:checkVC animated:YES];
                };
                [self.view addSubview:tipView];
            }else{
                TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, 330, 150, 30) Title:@"发送失败，请重试" Time:2];
                [self.view addSubview:tipView];
                NSLog(@"==========%@",error);
            }
        }];

    }
}
         
- (void)tipMiss{
    [_labTip removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
