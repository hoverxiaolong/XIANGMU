//
//  ThirdView.h
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^Sina)();

typedef void(^Qq)();

@interface ThirdView : UIView

@property (nonatomic,strong) Sina sinaBlock;

@property (nonatomic,strong) Qq qqBlock;

@property (strong, nonatomic) UILabel *lineOneLabel;
@property (strong, nonatomic) UILabel *hezuoLabel;
@property (strong, nonatomic) UILabel *lineTwoLabel;
//两大平台图片
@property (strong, nonatomic) UIImageView *sinaImageView;

@property (strong,nonatomic) UIButton *sina;

@property (strong,nonatomic) UIButton *qq;

@property (strong, nonatomic) UIImageView *QQImageView;

@end
