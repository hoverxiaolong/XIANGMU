//
//  ShouyeViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "ShouyeViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "CehuaViewController.h"
#import "SYModel.h"
#import "SYFrame.h"
#import "SYAllCell.h"
#import "SYHeadView.h"
#import "SYFootView.h"
#import <UMengSocialCOM/UMSocial.h>
#import "MYPromptTool.h"
#import "JXLDayAndNightMode.h"

//屏幕宽度
#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
//屏幕高度
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)


@interface ShouyeViewController ()<SYAllCellDelegate,UITextFieldDelegate,SYFootViewDelegate,UMSocialUIDelegate>
{
    //坐标
    CGRect   _frame;
}
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,weak) UIImageView *fangda;
@property (nonatomic,strong) NSString *bigName;
@property (nonatomic,weak) UIButton *cover;


@property (nonatomic,copy) NSMutableArray *examArray;

@end

@implementation ShouyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航按钮和关联方法(唤醒侧滑菜单)
    UIBarButtonItem *menuItem = [UIBarButtonItem itemWithNormalIcon:@"menu" highlightedIcon:nil target:self action:@selector(openSideMenuMethod)];
    
    
    UIBarButtonItem *titleItem = [UIBarButtonItem itemWithTitle:@"我的首页" target:nil action:nil];
    
    self.navigationItem.leftBarButtonItems = @[menuItem,titleItem];
    //为配图的点击注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(examCellWithPictureChangeBig:) name:@"pictureClick" object:nil];
    
    self.tableView.tableHeaderView = [SYHeadView loadHeadView];
    
    SYFootView *foot = [SYFootView loadFootView];
    self.tableView.tableFooterView = foot;
    foot.delegate = self;

    [self config];
}

//背景
- (void)config {
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
        bar.barTintColor = [UIColor cyanColor];
    }];
    
}



//唤醒侧滑菜单
- (void)openSideMenuMethod
{
    [CehuaViewController openSideMenuFromWindow:self.view.window];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)examArray {
    
    //先判断数组是否为空，如果为空就加载数据
    if (_examArray == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"exam" ofType:@"plist"];
        
        //读取数据到数组中
        NSArray *temp = [NSArray arrayWithContentsOfFile:path];
        
        //创建一个可变的临时数组，用来暂时存放转换后的模型数据
        NSMutableArray *mutArray = [NSMutableArray array];
        for (NSDictionary *dict in temp) {
            SYModel *model = [SYModel shouWithDictionary:dict];
            self.model = model;
            SYFrame *frame = [[SYFrame alloc] init];
            frame.sy = model;
            //将模型存放到临时数组
            [mutArray addObject:frame];
        }
        _examArray = mutArray;
        
    }
    return _examArray;
}


#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.examArray.count;
}

#pragma mark - footView代理方法
- (void)SYFootViewClickLoadBtn:(SYFootView *)footView {
    
    // 当点击加载数据按钮的时候，调用模拟网络请求方法
    [self imitateNetWorkRequestLoadData];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYAllCell *cell = [SYAllCell cellWithTableView:tableView];
    __weak typeof(self) weakSelf = self;
    
    [cell setZhuanfa:^{
    
        
        [UMSocialData defaultData].extConfig.title = self.model.name;
        [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"57d3e905e0f55a0b7000125a"
                                          shareText:self.model.content
                                         shareImage:[UIImage imageNamed:self.model.icon]
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                           delegate:weakSelf];

    
    }];
    
    __weak typeof(cell) weak = cell;
    
    [weak setDianzan:^{
    
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"identifier"];
        UMSocialDataService *socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
        [socialDataService postAddLikeOrCancelWithCompletion:^(UMSocialResponseEntity *response){
            //获取请求结果
            //NSLog(@"resposne is %@",response);
        }];
        //__weak typeof(cell) weak = cell;
        BOOL isLike = socialData.isLike;
        if (isLike) {
            weak.supportBtn.selected = YES;
            [MYPromptTool promptModeText: @"已添加到喜欢" afterDelay:1];
        }else if(!isLike){
            cell.supportBtn.selected = NO;
            
            [MYPromptTool promptModeText: @"取消喜欢" afterDelay:1];
        }
        
        [socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
            // 下面的方法可以获取保存在本地的评论数，如果app重新安装之后，数据会被清空，可能获取值为0
            //NSInteger likeNumber = [socialDataService.socialData getNumber:UMSNumberLike];
            //NSLog(@"likeNum is %ld",likeNumber);
        }];
    
    }];
    
    SYFrame *frame = self.examArray[indexPath.row];
    cell.examFrame = frame;
    cell.delegate = self;
    return cell;
}

#pragma mark - tabelView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYFrame *frame = self.examArray[indexPath.row];
    return frame.cellHeight;
}

#pragma mark - 决定哪一行是可以编辑的
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark - 决定表格的编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row % 2 ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleInsert;
}

#pragma mark - 根据传入的editingStyle的模式来判断是哪种编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.examArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        
        SYFrame *frame = [[SYFrame alloc] init];
        //数组中元素的总个数
        NSInteger count = self.examArray.count;
        
        NSInteger index = arc4random()%count;
        //取出随机数对应的模型
        frame = self.examArray[index];
        
        [self.examArray insertObject:frame atIndex:indexPath.row + 1];
        
        [self.tableView reloadData];
        
        //让tableView自动滚动到刚插入数据的位置
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - 决定删除按钮上显示的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

#pragma mark - 被选中的行能否移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//重写这个方法，支持重新排序，界面上的排序工作已经完成，但是数据源不会发生变化
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSInteger from = [fromIndexPath row];
    NSInteger to = [toIndexPath row];
    //获取将要移动的数据
    id target = [self.examArray objectAtIndex:from];
    
    //从数组中删除指定的数据项
    [self.examArray removeObjectAtIndex:from];
    //将要移动的数据插入到指定的位置
    [self.examArray insertObject:target atIndex:to];
}

//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //弹框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑" message:@"请在下面的文本框中修改你想要的数据" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    
    
    UIAlertAction *queding = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *name = [alert textFields][0];
        UITextField *content = [alert textFields][1];
        
        //取出textfield的内容
        NSString *name1 = name.text;
        NSString *content1 = content.text;
        
        //修改模型中的数据
        SYFrame *frame = self.examArray[indexPath.row];
        SYModel *model = frame.sy;
        //将textfield中的文字赋值给模型中的属性
        model.name = name1;
        model.content = content1;
        
        //重新计算文字的大小
        frame.sy = [frame sy];
        
        //刷新数据源
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
        [alert addAction:queding];
        
        //取出选中行对应的模型
        SYFrame *syFrame = self.examArray[indexPath.row];
        SYModel *syModel = syFrame.sy;
        
        //添加输入框
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            //将选中行对应的标题赋值给输入框
            textField.text = syModel.name;
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.text = syModel.content;
        }];
        
    //弹框显示
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)randomData {
    
    SYFrame *frame = [[SYFrame alloc] init];
    NSInteger count = self.examArray.count;
    NSInteger index = arc4random()%count;
    //取出随机数对应的模型
    frame = self.examArray[index];
    [self.examArray addObject:frame];
    
    [UIView animateWithDuration:0.2 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tableView reloadData];
        
    } completion:^(BOOL finished) {
        //自动滚到最后一行
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.examArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }];
}

#pragma mark - 手动创建模拟网路请求
-(void)imitateNetWorkRequestLoadData{
    // 添加个view
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor whiteColor];
    CGFloat mainViewW = 160;
    CGFloat mainViewH = mainViewW;
    CGFloat mainViewX = ([UIScreen mainScreen].bounds.size.width - mainViewW) * 0.5;
    CGFloat mainViewY = ([UIScreen mainScreen].bounds.size.height - mainViewH) * 0.5;
    mainView.frame = CGRectMake(mainViewX, mainViewY, mainViewW, mainViewH);
    mainView.center = self.view.center;
    mainView.alpha = 0.5;
    mainView.layer.cornerRadius = 25;
    mainView.clipsToBounds = YES;
    [self.tableView.superview addSubview:mainView];
    
    // 用来添加对号的view
    UIImageView *right = [[UIImageView alloc] init];
    right.image = [UIImage imageNamed:@"activity"];
    right.hidden = YES;
    [mainView addSubview:right];
    CGFloat rightW = 80;
    CGFloat rightH = 80;
    CGFloat rightX = (mainViewW - rightW) * 0.5;
    CGFloat rightY = 20;
    right.frame = CGRectMake(rightX, rightY, rightW, rightH);
    [mainView addSubview:right];
    
    // 底部的文字
    UILabel *intro = [[UILabel alloc] init];
    
    intro.font = [UIFont boldSystemFontOfSize:17];
    intro.textAlignment = NSTextAlignmentCenter;
    intro.textColor = [UIColor blackColor];
    intro.text = [NSString stringWithFormat:@"正在更新数据..."];
    CGFloat introX = 0;
    CGFloat introW = mainViewW;
    CGFloat introH = 50;
    CGFloat introY = CGRectGetMaxY(right.frame);
    intro.frame = CGRectMake(introX, introY, introW, introH);
    [mainView addSubview:intro];
    
    // 菊花
    UIActivityIndicatorView *rotation = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    rotation.center = CGPointMake(mainViewW * 0.5, mainViewH * 0.5 - 20);
    [rotation startAnimating];
    //    rotation.hidden = NO;
    rotation.color = [UIColor greenColor];
    //    rotation.hidesWhenStopped = YES;
    [mainView addSubview:rotation];
    
    // 2.动画
    [UIView animateWithDuration:3.0 animations:^{
        self.tableView.alpha = 0.1;
        [self.tableView.superview bringSubviewToFront:mainView];
        mainView.alpha = 1.0;
        // 禁止用户进行点击操作
        self.tableView.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self randomData];
            [self.tableView reloadData];
            intro.text = [NSString stringWithFormat:@"数据已更新完毕."];
            [rotation stopAnimating];
            right.hidden = NO;
            mainView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.tableView.alpha = 1.0;
            [mainView removeFromSuperview];
            self.tableView.userInteractionEnabled = YES;
        }];
    }];
}

//回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//将要编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //NSLog(@"将要编辑");
    return YES;
}
//点击键盘调用
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //NSLog(@"点击键盘调用");
    return YES;
}

#pragma mark - 利用代理实现头像的点击
- (void)examCellWithIconImageAddHandclick:(SYAllCell *)celled {
    
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:NO];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
}

#pragma mark - 利用通知实现头像的点击
-(void)iconImageHandClick:(NSNotification *)not{
    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - 利用通知实现配图的点击事件
- (void)examCellWithPictureChangeBig:(NSNotification *)notification {
    //取出要改变图片的名字
    self.bigName = notification.userInfo[@"picture"];
    [self clickPictureTobig];
    
}

- (void)clickPictureTobig {
    
    UIImageView *big = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5, ScreenHeight * 0.5, 0, 0)];
    UIImage *image = [UIImage imageNamed:self.bigName];
    big.image = image;
    big.userInteractionEnabled = NO;
    [self.tableView.window addSubview:big];
    self.fangda = big;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    btn.backgroundColor = [UIColor blueColor];
    btn.alpha = 0.0;
    [btn addTarget:self action:@selector(transform) forControlEvents:UIControlEventTouchDown];
    [self.tableView.superview addSubview:btn];
    self.cover = btn;
    [self transform];
}

- (void)transform {
    if (self.cover.alpha == 0.0) {
        
        //将图片移动到视图的顶层
        [self.view.superview bringSubviewToFront:self.fangda];
        self.cover.alpha = 0.0;
        //放大
        CGFloat imageWidth = ScreenWidth;
        CGFloat imageHeight = imageWidth;
        CGFloat imageY = (ScreenHeight - ScreenWidth) * 0.5;
        [UIView animateWithDuration:1.0 animations:^{
            
            self.cover.alpha = 0.7;
            self.fangda.alpha = 1.0;
            self.fangda.frame = CGRectMake(0, imageY, imageWidth, imageHeight);
        }];
    }else{
        
        [UIView animateWithDuration:1.0 animations:^{
            
            self.fangda.frame = CGRectMake(ScreenWidth * 0.5, ScreenHeight * 0.5, 0, 0);
            self.fangda.alpha = 0.0;
            //遮罩透明了
            self.cover.alpha = 0.0f;
        }completion:^(BOOL finished) {
            [self.fangda removeFromSuperview];
            [self.cover removeFromSuperview];
            
        }];
    }
    
}

//移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
