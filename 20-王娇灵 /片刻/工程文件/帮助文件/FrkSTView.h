//
//  FrkSTView.h
//  心情语录
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
///

#import <UIKit/UIKit.h>

@interface FrkSTView : UIView
//要把loading界面加载到哪个界面上
+ (void)showFrkSTViewFromSuperView:(UIView*)superView;
//要把loading界面从哪个界面上移除
+ (void)removeFrkSTViewFromSuperView:(UIView*)superView;
//要把loading界面加载到哪个界面上（具体位置多少）
+ (void)showFrkSTViewFromSuperView:(UIView *)superView offsetY:(CGFloat)offsetY;

@end
