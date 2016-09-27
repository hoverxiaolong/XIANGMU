//
//  LoginViewController.m
//  UStory
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "LoginViewController.h"
#import "ResetPWViewController.h"
#import "RegistViewController.h"
#import "ForgetPWViewController.h"
#import "MainViewController.h"
#import "ControVC.h"

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak UITextField *_txfPhone;
    __weak UITextField *_txfPassword;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(25);
        make.top.equalTo(self.view).offset(150);
        make.trailing.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(106);
        
    }];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    //隐藏分割线
    //tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //删除多余的行
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        // 如果tableView响应了setSeparatorInset: 这个方法,我们就将tableView分割线的内边距设为0.
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        // 如果tableView响应了setLayoutMargins: 这个方法,我们就将tableView分割线的间距距设为0.
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    /** 登录按钮 */
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.backgroundColor = [UIColor cyanColor];
    [loginBtn setTitle:@"登\t录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(tableView);
        make.top.equalTo(tableView.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(didTapLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    /** 忘记密码 */
    UIButton *forgetPWBtn = [[UIButton alloc]init];
    [forgetPWBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetPWBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPWBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    forgetPWBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:forgetPWBtn];
    [forgetPWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_centerX).offset(-5);
        make.top.equalTo(loginBtn.mas_bottom).offset(50);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(60);
    }];
    [forgetPWBtn addTarget:self action:@selector(didTapForgetPWBtn) forControlEvents:UIControlEventTouchUpInside];
    
    /** 注册账号 */
    UIButton *registBtn = [[UIButton alloc]init];
    [registBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    registBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_centerX).offset(5);
        make.top.bottom.equalTo(forgetPWBtn);
        make.width.mas_equalTo(60);
    }];
    [registBtn addTarget:self action:@selector(didTapRegistBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_centerX).offset(-0.5);
        make.top.bottom.equalTo(registBtn);
        make.width.mas_equalTo(1);
    }];
    
    /** 取消按钮 */
    UIButton *btnCancel = [[UIButton alloc]init];
    [btnCancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.view addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(loginBtn);
        make.bottom.equalTo(tableView.mas_top).offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    [btnCancel addTarget:self action:@selector(didTapBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strId = @"LoginCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
        cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        if (indexPath.row == 0) {
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@"phone"];
            [cell.contentView addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(cell.contentView).offset(12);
                make.width.height.mas_equalTo(20);
            }];
            
            UITextField *txfPhone = [[UITextField alloc]init];
            txfPhone.keyboardType = UIKeyboardTypeNumberPad;
            txfPhone.placeholder = @"手机号";
            txfPhone.font = [UIFont systemFontOfSize:16];
            txfPhone.clearButtonMode = UITextBorderStyleLine;
            [cell.contentView addSubview:txfPhone];
            [txfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(image.mas_trailing).offset(15);
                make.top.equalTo(cell.contentView).offset(10);
                make.bottom.trailing.equalTo(cell.contentView).offset(-10);
            }];
            _txfPhone = txfPhone;
        }else{
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@"password"];
            [cell.contentView addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.equalTo(cell.contentView).offset(12);
                make.width.height.mas_equalTo(20);
            }];
            
            UITextField *txfPassword = [[UITextField alloc]init];
            txfPassword.placeholder = @"密码";
            txfPassword.secureTextEntry = YES;
            txfPassword.font = [UIFont systemFontOfSize:16];
            txfPassword.clearButtonMode = UITextBorderStyleLine;
            [cell.contentView addSubview:txfPassword];
            [txfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(image.mas_trailing).offset(15);
                make.top.equalTo(cell.contentView).offset(10);
                make.bottom.trailing.equalTo(cell.contentView).offset(-10);
            }];
            _txfPassword = txfPassword;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - ▷ 点击登录按钮 ◁
- (void)didTapLoginBtn{
    [AVUser logInWithUsernameInBackground:_txfPhone.text password:_txfPassword.text block:^(AVUser *user, NSError *error) {
        //登录成功
        if (user != nil) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setValue:_txfPhone.text forKey:@"usersPhone"];
            [userDefault synchronize];
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, ScreenHeight - 150, 100, 30) Title:@"登录成功" Time:1.5];
            tipView.blkTipView = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            [self.view addSubview:tipView];
        }
        //登录失败
        else {
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败，请检查手机号密码是否正确" preferredStyle:UIAlertControllerStyleAlert];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertCtrl animated:YES completion:nil];
        }
    }];
}

#pragma mark - ▷ 忘记密码 ◁
- (void)didTapForgetPWBtn{
    ForgetPWViewController *forgetVC = [[ForgetPWViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - ▷ 点击注册账号 ◁
- (void)didTapRegistBtn{
    RegistViewController *registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)didTapBtnCancel{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
