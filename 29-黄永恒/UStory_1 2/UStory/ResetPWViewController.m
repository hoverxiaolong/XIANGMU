//
//  ResetPWViewController.m
//  UStory
//
//  Created by qingyun on 16/8/29.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ResetPWViewController.h"
#import "SlipTitleView.h"
#import "LoginViewController.h"

@interface ResetPWViewController ()<UITableViewDataSource>
{
    __weak UITextField *_txfCode;
    __weak UITextField *_txfReWord;
}
@end

@implementation ResetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;

    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"重设密码"];
    titleView.backgroundColor = randomColor;
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.text =[NSString stringWithFormat:@"提示:若验证失败，请返回上一页重新发送验证码"];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(25);
        make.top.equalTo(titleView.mas_bottom).offset(15);
        make.trailing.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(60);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(35);
        make.height.mas_equalTo(43 * 2);
    }];
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    
    UIButton *certainBtn = [[UIButton alloc]init];
    certainBtn.backgroundColor = [UIColor cyanColor];
    [certainBtn setTitle:@"确\t定" forState:UIControlStateNormal];
    [self.view addSubview:certainBtn];
    [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(tableView);
        make.top.equalTo(tableView.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    certainBtn.layer.cornerRadius = 5;
    certainBtn.layer.masksToBounds = YES;
    [certainBtn addTarget:self action:@selector(didTapCertainBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strId = @"resetVC";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
        cell.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        if (indexPath.row == 0) {
            
            UITextField *txfCode = [[UITextField alloc]init];
            txfCode.placeholder = @"验证码";
            txfCode.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:txfCode];
            [txfCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(10);
                make.top.bottom.equalTo(cell.contentView);
                make.trailing.equalTo(cell.contentView).offset(-10);
            }];
            _txfCode = txfCode;
        }
        else{
            UITextField *txfReWord = [[UITextField alloc]init];
            txfReWord.placeholder = @"设置新密码";
            txfReWord.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:txfReWord];
            [txfReWord mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(10);
                make.top.bottom.equalTo(cell.contentView);
                make.trailing.equalTo(cell.contentView).offset(-10);
            }];
            _txfReWord = txfReWord;
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

- (void)didTapCertainBtn{
    [AVUser resetPasswordWithSmsCode:_txfCode.text newPassword:_txfReWord.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"修改成功");
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, ScreenHeight - 200, 100, 30) Title:@"密码修改成功，请重新登录" Time:1];
            tipView.blkTipView = ^{
                LoginViewController *login = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];
            };
            [self.view addSubview:tipView];
        } else {
            NSLog(@"修改失败");
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, ScreenHeight - 200, 100, 30) Title:@"修改失败" Time:2];
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
