//
//  CheckPhoneVC.m
//  UStory
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CheckPhoneVC.h"
#import "LoginViewController.h"

@interface CheckPhoneVC ()
{
    __weak UITextField *_textField;
}
@end

@implementation CheckPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    textField.placeholder = @"输入手机验证码";
    textField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(250));
        make.top.equalTo(self.view).offset(150);
        make.height.mas_equalTo(40);
    }];
    _textField = textField;
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"验  证" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(textField);
        make.top.equalTo(textField.mas_bottom).offset(30);
        make.height.equalTo(@(40));
    }];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(checkCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reSendCode = [[UIButton alloc]init];
    reSendCode.titleLabel.font = [UIFont systemFontOfSize:13];
    [reSendCode setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [reSendCode setTitle:@"重新发送验证码" forState:UIControlStateNormal];
    [self.view addSubview:reSendCode];
    [reSendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(100));
        make.top.equalTo(btn.mas_bottom).offset(20);
        make.height.mas_equalTo(15);
    }];
    [reSendCode addTarget:self action:@selector(reSendCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *horView = [[UIView alloc]init];
    horView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:horView];
    [horView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(reSendCode);
        make.height.equalTo(@(1));
        make.top.equalTo(reSendCode.mas_bottom).offset(-1);
    }];
}

#pragma mark - ▷ 验证手机号 ◁
- (void)checkCode{
    [AVUser verifyMobilePhone:_textField.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 330, 100, 30) Title:@"验证手机号成功" Time:1];
            [self.view addSubview:tipView];
            tipView.blkTipView = ^{
                LoginViewController *login = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];
            };
        }
        else{
            NSLog(@"验证失败");
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, 330, 150, 50) Title:@"验证失败，请重新获取验证码" Time:2];
            [self.view addSubview:tipView];
        }
    }];
}

#pragma mark - ▷ 重新发送验证码 ◁
- (void)reSendCode{
    [AVUser requestMobilePhoneVerify:self.strPhoneNum withBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 330, 100, 30) Title:@"发送成功" Time:1];
            [self.view addSubview:tipView];
        }else{
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 330, 150, 30) Title:@"发送失败，请重试" Time:2];
            [self.view addSubview:tipView];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
