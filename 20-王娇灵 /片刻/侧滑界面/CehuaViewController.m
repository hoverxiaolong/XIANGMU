//
//  CehuaViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "CehuaViewController.h"
#import "DiaoduControllerDispatch.h"
#import "CehuaTableViewCell.h"
#import "Masonry.h"
#import "SliderHeadView.h"
#import "LoadViewController.h"
//#import "SliderFootView.h"
#import "QYAccout.h"
#import "ZhuceViewController.h"
#import "ShezhiViewController.h"
#import "LXAlertView.h"

@interface CehuaViewController ()<UITableViewDataSource,UITableViewDelegate>
//背景遮罩
@property (strong, nonatomic) UIView *backgroundImageView;
//内容视图
@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) NSUInteger selectIndex;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *yonghuImageView;
@property (strong, nonatomic) UIButton *loadingButton;
//下载
@property (strong, nonatomic) UIButton *downloadButton;

//喜欢
@property (strong, nonatomic) UIButton *loveButton;

//信息
@property (strong, nonatomic) UIButton *messageButton;

//编辑
@property (strong, nonatomic) UIButton *editButton;
//搜索button
@property (strong, nonatomic) UIButton *searchButton;
//分类数组
@property (strong, nonatomic) NSArray *tableviewArray;
//图片数组
@property (strong, nonatomic) NSArray *imageArray;
//侧边栏headerView
@property (strong, nonatomic) SliderHeadView *headView;
//侧边栏footview
//@property (strong, nonatomic) SliderFootView *footView;


@end

@implementation CehuaViewController

//登录之后更新侧滑控制器里面的用户名和头像
-(void)viewWillAppear:(BOOL)animated{
    ShezhiViewController *she = [[ShezhiViewController alloc] init];
    //判断是否登录
    if ([QYAccout shareAccount].username) {
       
        //刷新显示内容
        [self.headView.userNameButton setTitle:[QYAccout shareAccount].username forState:UIControlStateNormal];
        [self.headView.headImageButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        self.headView.layer.cornerRadius = 45;
        self.headView.layer.masksToBounds = YES;
        

        
    }else if([QYAccout shareAccount].username == nil){
        //[[QYAccout shareAccount] logOut];
        
         [self.headView.headImageButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        [self.headView.userNameButton setTitle:@"登录/注册"forState:UIControlStateNormal];
        [she.button setTitle:@"登录" forState:UIControlStateNormal];
        [she.button addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];

    }
    
}

- (void)toLogin {
    
    LoadViewController *load = [[LoadViewController alloc] init];
    [self presentViewController:load animated:YES completion:nil];
}

- (void)noLogin {
    
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗?" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        
        [self logOut];
        
    }];
    
    
    [alert showLXAlertView];
    
    
}
- (void)logOut {
    
    [[QYAccout shareAccount] logOut];
    
    LoadViewController *load = [[LoadViewController alloc] init];
    [self presentViewController:load animated:YES completion:nil];
}



+ (instancetype)shareSideMenu
{
    static CehuaViewController *sideMenu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sideMenu = [self new];
    });
    return sideMenu;
    
}


//唤醒侧边菜单方法
+ (void)openSideMenuFromWindow:(UIWindow*)window
{
    //每次调用都能保证唤醒的侧边菜单是唯一的一个
    CehuaViewController *sideMenu1 = [CehuaViewController shareSideMenu];
    [window addSubview:sideMenu1.view];
    
    //唤醒之后，需要让侧边菜单移动进入当前视图
   
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = sideMenu1.contentView.frame;
        rect.origin.x = 0;
        sideMenu1.contentView.frame = rect;
        sideMenu1.backgroundImageView.alpha = 0.5;
    }];
    
}


//侧滑菜单收回
- (void)closeSideMenu:(NSInteger)index
{
    //如何拿到已经被唤醒的侧滑菜单
    [UIView animateWithDuration:0.5 animations:^{
        //侧滑菜单收回
        CGRect rect = self.contentView.frame;
        rect.origin.x = -rect.size.width;
        self.contentView.frame = rect;
        self.backgroundImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        //将侧滑菜单从当前视图中移除
        [self.view removeFromSuperview];
        
        //进入相应的选择界面
        [DiaoduControllerDispatch createViewControllerWithIndex:index];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载视图
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.contentView];
    
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideMenu:)];
    [self.backgroundImageView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.backgroundImageView addGestureRecognizer:pan];
    
    _selectIndex = 10000;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.contentView.frame.size.height * 0.3, self.contentView.frame.size.width , self.contentView.frame.size.height * 0.45) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    
    //消除多余行
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableviewArray = @[@"我的首页",@"我的收藏",@"生活感悟",@"我的音乐",@"设置"];
    self.imageArray = @[@"home",@"radio",@"reading",@"peoples",@"setting"];
    [self.contentView addSubview:self.tableView];
    
    

    [self.contentView addSubview:self.headView];
    //[self.contentView addSubview:self.footView];
    //添加约束
    __weak typeof(self.contentView)weakSelf = self.contentView;
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        /*
         因为_headerView是加载在ContentView之上
         所以_headerView的约束是根据ContentView来计算的
         因此在block当中weakSelf必须为contentView类型
         */
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.height.equalTo([UIScreen mainScreen].bounds.size.height/6);
    }];
//    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.mas_left);
//        make.right.equalTo(weakSelf.mas_right);
//        make.bottom.equalTo(weakSelf.mas_bottom);
//        make.height.equalTo([UIScreen mainScreen].bounds.size.height/8);
//    }];

}

- (void)panAction:(UIPanGestureRecognizer *)panGesture {
    
    //NSLog(@"pan");
}


//创建用户头像
- (void)createYonghuImageView
{
    self.yonghuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 100,100)];
    self.yonghuImageView.image = [UIImage imageNamed:@"yh"];
    [self.contentView addSubview:self.yonghuImageView];
    
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableviewArray.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellId";
    CehuaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CehuaTableViewCell" owner:nil options:nil].lastObject;

    }
    cell.textLabel.text = [_tableviewArray objectAtIndex:indexPath.row];
    cell.imageView.image =[UIImage imageNamed: [_imageArray objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self closeSideMenu:indexPath.row];
    
}

#pragma mark - 懒加载
- (UIView*)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundImageView.backgroundColor = [UIColor blackColor];
        _backgroundImageView.alpha = 0;
    }
    return _backgroundImageView;
    
}

- (UIView*)contentView
{
    if (!_contentView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(-rect.size.width * 0.8, 0, rect.size.width * 0.8, rect.size.height)];
        _contentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        
    }
    
    return _contentView;
    
}


/*
 这个方法是点击headView之后跳转到登录页面
*/

-(SliderHeadView *)headView
{
    if (!_headView) {
        
    
    _headView = [[SliderHeadView alloc] init];
    if ([QYAccout shareAccount].username) {
        [_headView.headImageButton addTarget:self action:@selector(moveToShezhiViewController) forControlEvents:UIControlEventTouchUpInside];
        
        [_headView.userNameButton addTarget:self action:@selector(moveToShezhiViewController) forControlEvents:UIControlEventTouchUpInside];

    }else if([QYAccout shareAccount].username == nil){
    
        [_headView.headImageButton addTarget:self action:@selector(moveToLoadViewController) forControlEvents:UIControlEventTouchUpInside];
        [_headView.userNameButton addTarget:self action:@selector(moveToLoadViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    }
    return _headView;
}

- (void)moveToShezhiViewController {
    
    __weak typeof(self) weakSelf = self;
    ShezhiViewController *VC = [[ShezhiViewController alloc] init];
    
    [weakSelf presentViewController:VC animated:YES completion:^{
        [weakSelf.view removeFromSuperview];
       // NSLog(@"跳转到设置");
        
        [weakSelf closeSideMenu:4];
    }];
    
}

- (void)moveToLoadViewController
{
    LoadViewController *loadVC = [[LoadViewController alloc] init];
    
    [self presentViewController:loadVC animated:YES completion:nil];
    
}

//- (SliderFootView*)footView
//{
//    if (!_footView) {
//        _footView = [[SliderFootView alloc] init];
//        [_footView setBackgroundColor:[UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1.0f]];
//        
//    }
//    return _footView;
//}



@end
