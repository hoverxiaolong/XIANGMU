//
//  RadioViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "ShoucangViewController.h"
#import "CehuaViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "SQLHandler.h"
#import "SaveTableViewCell.h"
#import "MYPublicSongDetailModel.h"
#import "JXLDayAndNightMode.h"
#import "MYPlayingViewController.h"
#import "MYPublicTableView.h"
#import "MYMusicModel.h"
#import "QYAccout.h"


#define HCUrl @"http://tingapi.ting.baidu.com/v1/restserver/ting"

#define HCParams(...) @{@"from":@"ios",@"version":@"5.5.6",@"channel":@"appstore",@"operator":@"1",@"format":@"json",__VA_ARGS__}

@interface ShoucangViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MYPublicTableView *tableView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSMutableArray *mutArry;
@property (nonatomic,strong) MYPublicSongDetailModel *model;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;

@end

@implementation ShoucangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self createTableView];
    [self yejing];

    //设置导航按钮和关联方法(唤醒侧滑菜单)
    UIBarButtonItem *menuItem = [UIBarButtonItem itemWithNormalIcon:@"menu" highlightedIcon:nil target:self action:@selector(openSideMenuMethod)];
    
    UIBarButtonItem *titleItem = [UIBarButtonItem itemWithTitle:@"我的收藏" target:nil action:nil];
    
    self.navigationItem.leftBarButtonItems = @[menuItem,titleItem];
  
}

- (void)yejing {
    [self.view jxl_setDayMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    } nightMode:^(UIView *view) {
        
        self.view.backgroundColor = [UIColor blackColor];
    }];
    
    [self.navigationController.navigationBar jxl_setDayMode:^(UIView *view) {
        UINavigationBar *bar = (UINavigationBar *)view;
        bar.barStyle = UIBarStyleDefault;
        bar.barTintColor = [UIColor redColor];
    } nightMode:^(UIView *view) {
        UINavigationBar *bar = (UINavigationBar *)view;
        bar.barStyle = UIBarStyleDefault;
        bar.barTintColor = [UIColor greenColor];
    }];
    
}


- (NSMutableArray *)songIdsArrayM {
    
    if (!_songIdsArrayM) {
        _songIdsArrayM = [NSMutableArray arrayWithCapacity:self.mutArry.count];
        NSMutableArray *mut = [NSMutableArray array];
        
        for (NSInteger inde = 0; inde < self.mutArry.count; inde++) {
            
            self.model = self.mutArry[inde];
            [mut addObject:self.model.song_id];
            
        }

        _songIdsArrayM = [mut copy];
    }
    return _songIdsArrayM;
}

- (void)config {
    self.view.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:0.5];
    self.navigationItem.title = @"收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
//    if (![QYAccout shareAccount].isLogin) {
//        return;
//    }
    //[super viewWillAppear:animated];
    [[SQLHandler shareInstance] openDB];
    self.mutArry = [NSMutableArray array];
    UITableView *tableView = [self.view viewWithTag:9000];
    
    self.mutArry = [[SQLHandler shareInstance] selectAll];
    
     [tableView reloadData];
}

- (void)createTableView {
    
    self.tableView = [[MYPublicTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 100;
    self.tableView.tag = 9000;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SaveTableViewCell class] forCellReuseIdentifier:@"cell"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mutArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    self.model = self.mutArry[indexPath.row];
    cell.model = self.model;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //从分组中删除联系人
    MYPublicSongDetailModel *movie = self.mutArry[indexPath.row];
    [[SQLHandler shareInstance] delete:movie];
    [self.mutArry removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _model = self.mutArry[indexPath.row];
    NSInteger index1 = indexPath.row;
    
    MYPlayingViewController *viewController = [MYPlayingViewController sharePlayingVC];
    
    [viewController setSongIdArray:self.songIdsArrayM currentIndex:index1];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

//唤醒侧滑菜单
- (void)openSideMenuMethod
{
    [CehuaViewController openSideMenuFromWindow:self.view.window];
    
}


@end
