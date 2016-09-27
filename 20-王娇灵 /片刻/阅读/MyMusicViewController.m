//
//  MyMusicViewController.m
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import "MyMusicViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "CehuaViewController.h"
#import "GedanVC.h"
#import "XinquVC.h"
#import "SousuoVC.h"
#import "PaihangVC.h"
#import "MyNavigationVC.h"

@interface MyMusicViewController ()

@end

@implementation MyMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor brownColor]];
    
    //self.title = @"歌单";
    //设置导航按钮和关联方法(唤醒侧滑菜单)
    UIBarButtonItem *menuItem = [UIBarButtonItem itemWithNormalIcon:@"menu" highlightedIcon:nil target:self action:@selector(openSideMenuMethod)];
    
    UIBarButtonItem *titleItem = [UIBarButtonItem itemWithTitle:@"我的音乐" target:nil action:nil];
    
    self.navigationItem.leftBarButtonItems = @[menuItem,titleItem];
    
//    //这里开始写tabbar
//    GedanVC *gedan = [[GedanVC alloc] init];
//    [self addChildViewController:gedan WithTitle:@"歌单" image:@"songList_normal" selectedImage:@"songList_highLighted"];
    
    XinquVC *xinqu = [[XinquVC alloc] init];
    [self addChildViewController:xinqu WithTitle:@"新碟上架" image:@"songNewList_normal" selectedImage:@"songNewList_highLighted"];
    
       PaihangVC *paihang = [[PaihangVC alloc] init];
    [self addChildViewController:paihang WithTitle:@"排行" image:@"songRank_normal" selectedImage:@"songRank_highLighted"];
    
//    SousuoVC *sousuo = [[SousuoVC alloc] init];
//    [self addChildViewController:sousuo WithTitle:@"搜索" image:@"songSearch_normal" selectedImage:@"songSearch_highLighted"];
//    

    
}
//唤醒侧滑菜单
- (void)openSideMenuMethod
{
    [CehuaViewController openSideMenuFromWindow:self.view.window];
    
}

- (void)addChildViewController:(UIViewController *)childVc WithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    
    MyNavigationVC *naviVC = [[MyNavigationVC alloc] initWithRootViewController:childVc];
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    //将图片原始的样子显示出来，不自动渲染为其它颜色
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *text = [NSMutableDictionary dictionary];
    text[NSForegroundColorAttributeName] = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0];
    NSMutableDictionary *select = [NSMutableDictionary dictionary];
    select[NSForegroundColorAttributeName] = [UIColor colorWithRed:(252)/255.0 green:(12)/255.0 blue:(68)/255.0 alpha:1.0];
    [childVc.tabBarItem setTitleTextAttributes:text forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:select forState:UIControlStateSelected];
    [self addChildViewController:naviVC];
    
}

@end
