//
//  RegistViewController.m
//  UStory
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "RegistViewController.h"
#import "LoginViewController.h"
#import "CheckPhoneVC.h"

@interface RegistViewController ()<UITableViewDataSource>
{
    __weak UITextField *_txfPhone;
    __weak UITextField *_txfPassword;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    /** 表格视图 */
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(25);
        make.trailing.equalTo(self.view).offset(-25);
        make.top.equalTo(self.view).offset(70);
        make.height.mas_equalTo(44 * 2 +18);
    }];
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    /** 注册按钮 */
    UIButton *registBtn = [[UIButton alloc]init];
    registBtn.backgroundColor = [UIColor cyanColor];
    [registBtn setTitle:@"注\t册" forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(tableView);
        make.top.equalTo(tableView.mas_bottom).offset(40);
        make.height.mas_equalTo(40);
    }];
    registBtn.layer.cornerRadius = 5;
    registBtn.layer.masksToBounds = YES;
    [registBtn addTarget:self action:@selector(didTapRegistBtn) forControlEvents:UIControlEventTouchUpInside];
    
    /** 去登录按钮 */
    UIButton *gotoLogBtn = [[UIButton alloc]init];
    [gotoLogBtn setTitle:@"已有账号，去登录" forState:UIControlStateNormal];
    [gotoLogBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    gotoLogBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:gotoLogBtn];
    [gotoLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_centerX).offset(-53);
        make.trailing.equalTo(self.view.mas_centerX).offset(53);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(15);
    }];
    [gotoLogBtn addTarget:self action:@selector(didTapBtnBackToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(gotoLogBtn);
        make.top.equalTo(gotoLogBtn.mas_bottom).offset(2);
        make.height.mas_equalTo(1);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strId = @"registCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
        cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        if (indexPath.row == 0) {
            UITextField *txfPhone = [[UITextField alloc]init];
            txfPhone.placeholder = @"手机号";
            txfPhone.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:txfPhone];
            [txfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(10);
                make.trailing.equalTo(cell.contentView).offset(-10);
                make.top.bottom.equalTo(cell.contentView);
            }];
            _txfPhone = txfPhone;
        }
        else{
            UITextField *txfPassword = [[UITextField alloc]init];
            txfPassword.placeholder = @"密码（6-14位数字或者字母）";
            txfPassword.secureTextEntry = YES;
            txfPassword.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:txfPassword];
            [txfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(10);
                make.trailing.equalTo(cell.contentView).offset(-10);
                make.top.bottom.equalTo(cell.contentView);
            }];
            _txfPassword = txfPassword;
        }
    }
    return cell;
}

#pragma mark - ▷ 点击注册按钮事件 ◁
- (void)didTapRegistBtn{
    [self.view endEditing:YES];
    if (_txfPassword.text.length == 0) {
        TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 300, 100, 30) Title:@"请填写密码" Time:1.5];
        [self.view addSubview:tipView];
    }else if (_txfPhone.text.length != 11){
        TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 300, 100, 30) Title:@"请填写手机号" Time:1.5];
        [self.view addSubview:tipView];
    }
    else{
        AVUser *user = [AVUser user];//新建AVUser对象实例
        user.username = _txfPhone.text;
        user.password = _txfPassword.text;//设置密码
        user.email = nil;
        user.mobilePhoneNumber = _txfPhone.text;
        NSError *error = nil;
        [user signUp:&error];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"注册成功");
                TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, ScreenHeight - 300, 100, 30) Title:@"注册成功" Time:1];
                tipView.blkTipView = ^{
                    CheckPhoneVC *check = [[CheckPhoneVC alloc]init];
                    check.strPhoneNum = _txfPhone.text;
                    [self.navigationController pushViewController:check animated:YES];
                };
                [self.view addSubview:tipView];
            } else {
                NSLog(@"注册失败");
                TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, ScreenHeight - 300, 100, 30) Title:@"注册失败" Time:2];
                [self.view addSubview:tipView];
            }
        }];
    }
}

#pragma mark - ▷ 返回登录页面 ◁
- (void)didTapBtnBackToLogin{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(separatorInset)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
