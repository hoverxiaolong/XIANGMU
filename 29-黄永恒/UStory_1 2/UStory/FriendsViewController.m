//
//  FriendsViewController.m
//  UStory
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "FriendsViewController.h"
#import "SlipTitleView.h"
#import "AddFriendsVC.h"
#import "ChatVC.h"

@interface FriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic, strong)NSString *myname;//自己登录的名字
@property (nonatomic, strong)NSArray *friends;//好友数据源

@end

@implementation FriendsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //查询好友列表
    AVQuery *query = [AVQuery queryWithClassName:@"Friend"];
    //设置查询条件
    [query whereKey:@"myname" equalTo:self.myname];
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        self.friends = objects;
        [self.tableView reloadData];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    AVUser *currentUser = [AVUser currentUser];
    self.myname = currentUser.username;
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting{
    __weak typeof(self) selfWeak = self;
    
    SlipTitleView *titleView = [[SlipTitleView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 40) title:@"我的好友"];
//    titleView.backgroundColor = randomColor;
    [self.view addSubview:titleView];
    [titleView setBlkDidTapBackBtn:^{
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    /** 表格视图 */
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(titleView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    self.tableView = tableView;
    //删除多余的行
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - ▷ 单元数 ◁
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - ▷ 每单元表格数 ◁
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.friends.count;
}

#pragma mark - ▷ 单元表格内容 ◁
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSArray *title = @[@"添加好友"];
        NSArray *icon = @[@"addfriends"];
        NSString *strId = @"friendcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strId];
            cell.textLabel.text = title[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:icon[indexPath.row]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    NSString *strID = @"friends";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    AVObject *friend = self.friends[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:strID];
        UILabel *labTag = [[UILabel alloc]init];
        labTag.backgroundColor = [UIColor colorWithRed:164/255.0 green:206/255.0 blue:104/255.0 alpha:1];
        labTag.textAlignment = NSTextAlignmentCenter;
        labTag.text = [friend[@"friendname"] substringToIndex:1];
        labTag.textColor = [UIColor whiteColor];
        labTag.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:labTag];
        [labTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView).offset(15);
            make.top.equalTo(cell.contentView).offset(5);
            make.bottom.equalTo(cell.contentView).offset(-5);
            make.width.mas_equalTo(34);
        }];
        labTag.layer.cornerRadius = 17;
        labTag.layer.masksToBounds = YES;
        
        UILabel *labName = [[UILabel alloc]init];
        labName.font = [UIFont systemFontOfSize:15];
        labName.text = friend[@"friendname"];
        [cell.contentView addSubview:labName];
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(labTag.mas_trailing).offset(20);
            make.top.bottom.equalTo(cell.contentView);
            make.trailing.equalTo(cell.contentView).offset(-100);
        }];
    }
    return cell;
}

#pragma mark - ▷ 选中cell事件 ◁
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AddFriendsVC *addVC = [[AddFriendsVC alloc]init];
            [self.navigationController pushViewController:addVC animated:YES];
        }else{
            
        }
    }else{
        ChatVC *chatVC = [[ChatVC alloc]init];
        AVObject *friend = self.friends[indexPath.row];
        chatVC.strFriendName = friend[@"friendname"];
        chatVC.strFriendPhone = friend[@"friendphone"];
        chatVC.strMyName = friend[@"myname"];
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

#pragma mark - ▷ 表格单元header高度 ◁
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }return 30;
}

#pragma mark - ▷ 表格头视图表格 ◁
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor lightGrayColor];
    view.frame = CGRectMake(0, 0, 0, 50);
    [tableView addSubview:view];
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(15, 0, 100, 30);
    lab.font = [UIFont systemFontOfSize:12];
    lab.text = @"好友列表";
    [view addSubview:lab];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
