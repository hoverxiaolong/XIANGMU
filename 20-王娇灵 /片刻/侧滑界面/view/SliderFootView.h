//
//  SliderFootView.h
//  心情语录
//
//  Created by qingyun on 16/8/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderFootView : UIView
//长得像唱片的那个按钮
@property (strong, nonatomic) UIButton *changpianButton;
//大的lable
@property (strong, nonatomic) UILabel *bigLabel;
//小的label
@property (strong, nonatomic) UILabel *smallLabel;
//暂停按钮
@property (strong, nonatomic) UIButton *stopButton;

@end
