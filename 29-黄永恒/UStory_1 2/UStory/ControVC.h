//
//  ControVC.h
//  UStory
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SideslipViewController.h"

@interface ControVC : UIViewController

@property(nonatomic,strong)MainViewController *mainVC;
@property(nonatomic,strong)SideslipViewController *slipVC;

- (instancetype)initWithmainVC:(MainViewController *)mainVC slipVC:(SideslipViewController *)slipVC;

- (void)didTapSideslipHomeBtn;

@end
