//
//  ZJView.h
//  美物心语
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ZJView : UIView

//要把loading界面加载到哪个界面
+ (void)showZJViewFromSuperView:(UIView*)superView;

//要把loading界面从哪个界面移除
+ (void)removeZJViewFromSuperView:(UIView*)superView;

//要把loading界面加载到哪个界面上(具体位置多少)
+ (void)showZJVIEWFromSuperView:(UIView*)superView offSetY:(CGFloat)offsetY;
@end
