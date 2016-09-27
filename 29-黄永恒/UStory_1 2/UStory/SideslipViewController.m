//
//  SideslipViewController.m
//  UStory
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "SideslipViewController.h"
#import "SlipHeaderView.h"
#import "ControVC.h"
#import "FriendsViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "EditInfoViewController.h"
#import "SlipLoginHeader.h"
#import <LeanCloudFeedback/LeanCloudFeedback.h>
#import "TipView.h"

@interface SideslipViewController ()<UITableViewDelegate,UITableViewDataSource,SlipHeaderViewDelegate,SlipLoginDelegate>
{
    __weak SlipHeaderView *_headerView;
    __weak UITableView *_tableView;
    __weak UIActivityIndicatorView *_indicator;
    float ab;
}
@property(nonatomic,strong)NSArray *arrTitles;
@end

@implementation SideslipViewController

- (NSArray *)arrTitles{
    if (!_arrTitles) {
        _arrTitles = @[@{@"title":@"个人信息",@"icon":@"private"},
                       //@{@"title":@"好友列表",@"icon":@"friends"},
                       @{@"title":@"用户反馈",@"icon":@"feedback"},
                       @{@"title":@"清理缓存",@"icon":@"cache"}];
    }
    return _arrTitles;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划线
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [tableView reloadData];
    
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        NSLog(@"已经有登录");
        SlipLoginHeader *loginHeader = [[SlipLoginHeader alloc]init];
        loginHeader.backgroundColor = [UIColor cyanColor];
        loginHeader.frame = CGRectMake(0, 0, 0, 150);
        tableView.tableHeaderView = loginHeader;
        loginHeader.delegate = self;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *strName = [userDefault stringForKey:@"usersName"];
        if (strName.length == 0) {
            loginHeader.strUserName = currentUser.username;
        }else{
            loginHeader.strUserName = strName;
        }
        
    } else {
        NSLog(@"没有用户登录");
        SlipHeaderView *headerView = [[SlipHeaderView alloc]init];
        headerView.backgroundColor = [UIColor cyanColor];
        headerView.frame = CGRectMake(0, 0, 0, 150);
        tableView.tableHeaderView = headerView;
        headerView.delegate = self;
        _headerView = headerView;
    }
    
    UIButton *btnExit = [[UIButton alloc]init];
    btnExit.backgroundColor = [UIColor colorWithRed:105/255.0 green:193/255.0 blue:149/255.0 alpha:1];
    btnExit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnExit setTitle:@"退  出" forState:UIControlStateNormal];
    [btnExit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btnExit];
    [btnExit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(- 100 - 15);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.equalTo(@(40));
    }];
    btnExit.layer.cornerRadius = 5;
    btnExit.layer.masksToBounds = YES;
    [btnExit addTarget:self action:@selector(exitApp) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ▷ tableView数据源方法 ◁
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strId = @"slipcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
    }
    cell.imageView.image = [UIImage imageNamed:self.arrTitles[indexPath.row][@"icon"]];
    cell.textLabel.text = _arrTitles[indexPath.row][@"title"];
    return cell;
}

#pragma mark - ▷ tableView代理方法 ◁
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AVUser *currentUser = [AVUser currentUser];
    if (indexPath.row == 0) {
        //个人信息
        if (currentUser != nil) {
            EditInfoViewController *editVC = [[EditInfoViewController alloc]init];
            [self.navigationController pushViewController:editVC animated:YES];
        }else{
            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake((ScreenWidth)/2 - 50, ScreenHeight - 150, 100, 30) Title:@"请先登录" Time:1.5];
            [self.view addSubview:tipView];
        }
    }
//    else if (indexPath.row == 1) {
//        //好友列表
//        if (currentUser == nil) {
//            TipView *tipView = [[TipView alloc]initWithFrame:CGRectMake((ScreenWidth-100)/2 - 50, ScreenHeight - 150, 100, 30) Title:@"请先登录" Time:1.5];
//            [self.view addSubview:tipView];
//        }else{
//            FriendsViewController *friendsVC = [[FriendsViewController alloc]init];
//            [self.navigationController pushViewController:friendsVC animated:YES];
//        }
//    }
    else if (indexPath.row == 1){
        
        //反馈界面
        LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
        /* title 传 nil 表示将第一条消息作为反馈的标题。 contact 也可以传入 nil，由用户来填写联系方式。*/
        [agent showConversations:self title:nil contact:nil];
    }else{
        //清除缓存
        [self removeCache];
        [self cleanCache];
        //初始化:
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        //设置显示样式,见UIActivityIndicatorViewStyle的定义
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        //设置背景色
        indicator.backgroundColor = [UIColor blackColor];
        //设置背景透明
        indicator.alpha = 0.6;
        //设置背景为圆角矩形
        indicator.layer.cornerRadius = 6;
        indicator.layer.masksToBounds = YES;
        //设置显示位置
        [indicator setCenter:CGPointMake((self.view.frame.size.width-100) / 2.0, self.view.frame.size.height - 200)];
        //开始显示Loading动画
        [indicator startAnimating];
        [self.view addSubview:indicator];
        _indicator = indicator;
        
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(endRemoveCache) userInfo:nil repeats:NO];
    }

}

#pragma mark - ▷ SlipHeaderDelegate 代理方法 ◁
- (void)didTapSlipHeaderButtonWithTag:(NSInteger)tag{
    if (tag == 100 | tag == 102) {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
   }if (tag == 101){
    RegistViewController *registVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
   }
}

- (void)LoginHeaderView{
    EditInfoViewController *editVC = [[EditInfoViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (float)cleanCache{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManger fileExistsAtPath:path]) {
        /** 所有缓存文件数组 */
        NSArray *childFile = [fileManger subpathsAtPath:path];
        /** 拿到每个文件的名字，如果不想删除某个，在这里判断 */
        for (NSString *fileName in childFile) {
            /** 将路径拼凑到一起 */
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizePath:fullPath];
//            ab = folderSize;
        }
    }
    return folderSize;
}

#pragma mark - ▶ 计算文件大小 ◀
- (float)fileSizePath:(NSString *)path{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:path]) {
        long long size = [fileManger attributesOfItemAtPath:path error:nil].fileSize;
        float cacheM = size/1024.0/1024.0;
        ab = cacheM;
    }
    return ab;
}

- (void)removeCache{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:path]) {
        NSArray *childFiles = [fileManger subpathsAtPath:path];
        for (NSString *fileName in childFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManger removeItemAtPath:absolutePath error:nil];
        }
    }
}

- (void)endRemoveCache{
     [_indicator stopAnimating];
    TipView *tip = [[TipView alloc]initWithFrame:CGRectMake((ScreenWidth - 100)/2 - 75, ScreenHeight - 200, 150, 40) Title:[NSString stringWithFormat:@"清理缓存完成"] Time:1];
    [self.view addSubview:tip];
}

#pragma mark - ▷ 退出程序 ◁
- (void)exitApp{
    exit(0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
