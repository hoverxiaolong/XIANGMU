//
//  BaseViewController.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+Extension.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //动态更改导航背景/样式
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:[UIColor colorWithHexString:@"#303030"]];
    
    [bar setTintColor:[UIColor whiteColor]];
    
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
                                  }];
    //导航条中按钮的颜色
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
                                   }forState:UIControlStateNormal];
    
    
    
    
    
}

//更改状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
//    
//    self.navigationBar.tintColor = [UIColor blackColor];
//    [self.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    self.tabBarController.tabBar.hidden = NO;
//    return [super popToRootViewControllerAnimated:animated];
//}
//
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    
//    self.navigationBar.tintColor = [UIColor blackColor];
//    [self.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    self.tabBarController.tabBar.hidden = NO;
//    return [super popViewControllerAnimated:animated];
//    
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    [super pushViewController:viewController animated:YES];
//    if (self.viewControllers.count > 0) {
//        
//        viewController.navigationController.navigationBar.tintColor = [UIColor redColor];
//        viewController.tabBarController.tabBar.hidden = YES;
//    }
//}



@end
