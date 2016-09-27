//
//  AddFriendsVC.m
//  UStory
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "AddFriendsVC.h"
#import "SlipTitleView.h"
#import "TipView.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AddFriendsVC ()<UITableViewDataSource>
{
    __weak UITextField *_txfName;
    __weak UITextField *_txfPhone;
}
@end

@implementation AddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"好友标签"];
//    titleView.backgroundColor = randomColor;
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(90);
    }];
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    
    UIButton *certainBtn = [[UIButton alloc]init];
    certainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [titleView addSubview:certainBtn];
    [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(titleView).offset(-15);
        make.top.bottom.equalTo(titleView);
        make.width.mas_equalTo(50);
    }];
    [certainBtn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *icon = @[@"friends",@"phone"];
    NSString *strId = @"friendcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
        cell.imageView.image = [UIImage imageNamed:icon[indexPath.row]];
        if (indexPath.row == 0) {
            /** 好友名字 */
            UITextField *txfName = [[UITextField alloc]init];
            txfName.font = [UIFont systemFontOfSize:15];
            txfName.placeholder = @"请输入好友名字";
            [cell.contentView addSubview:txfName];
            [txfName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(60);
                make.top.bottom.trailing.equalTo(cell.contentView);
            }];
            _txfName = txfName;
        }else{
            /** 好友电话 */
            UITextField *txfPhone = [[UITextField alloc]init];
            txfPhone.font = [UIFont systemFontOfSize:15];
            txfPhone.placeholder = @"请输入好友手机号码";
            [cell.contentView addSubview:txfPhone];
            [txfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView).offset(60);
                make.top.bottom.trailing.equalTo(cell.contentView);
            }];
            _txfPhone = txfPhone;
        }
    }
    return cell;
}

#pragma mark - ▷ 添加好友 ◁
- (void)addFriend{
    if(_txfName.text == nil){
        TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, 200, 150, 30) Title:@"请填写好友昵称" Time:1.5];
        [self.view addSubview:tipView];
    }else if (_txfPhone.text == nil){
        
        TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, 200, 150, 30) Title:@"请填写好友手机号" Time:1.5];
        [self.view addSubview:tipView];
    }else{
        AVUser *currentUser = [AVUser currentUser];
        NSString *myName = currentUser.username;
        //向服务器添加一条记录
        AVObject *friend = [AVObject objectWithClassName:@"Friend"];
        [friend setObject:myName forKey:@"myname"];
        [friend setObject:_txfName.text forKey:@"friendname"];
        [friend setObject:_txfPhone.text forKey:@"friendphone"];
        //异步执行保存
        [friend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"保存成功");
                TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, 200, 150, 30) Title:@"添加好友成功" Time:1.5];
                tipView.blkTipView = ^{
                    [self.navigationController popViewControllerAnimated:YES];
                        };
                [self.view addSubview:tipView];
            }else{
                NSLog(@"%@", error);
                TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 75, 200, 150, 30) Title:@"添加好友失败" Time:1.5];
                [self.view addSubview:tipView];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
