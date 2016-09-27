//
//  MyNavigationVC.m
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MyNavigationVC.h"
#import "MYPlayingViewController.h"
#import "MYMusicIndicator.h"
#import "MYPromptTool.h"

#define HColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HCMainColor HColor(252,12,68)

@interface MyNavigationVC ()

@end

@implementation MyNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMusic];
}

- (void)setMusic {
    
    MYMusicIndicator *indicator = [MYMusicIndicator shareIndicator];
    indicator.hidesWhenStopped = NO;
    indicator.tintColor = HCMainColor;
    if (indicator.state != NAKPlaybackIndicatorViewStatePlaying) {
        indicator.state = NAKPlaybackIndicatorViewStatePaused;
    } else {
        indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMusicIndicator)];
    [indicator addGestureRecognizer:tap];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationBar addSubview:indicator];

}

- (void)clickMusicIndicator
{
    MYPlayingViewController *view = [MYPlayingViewController sharePlayingVC];
    if (!view.currentMusic) {
        [MYPromptTool promptModeText:@"没有正在播放的歌曲" afterDelay:1.0];
        return;
    }
    [self presentViewController:view animated:YES completion:^{
        
    }];
}



- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    
    self.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.tabBarController.tabBar.hidden = NO;
    return [super popToRootViewControllerAnimated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    self.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.tabBarController.tabBar.hidden = NO;
    return [super popViewControllerAnimated:animated];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:YES];
    if (self.viewControllers.count > 0) {
        
        viewController.navigationController.navigationBar.tintColor = [UIColor redColor];
        viewController.tabBarController.tabBar.hidden = YES;
    }
}



@end
