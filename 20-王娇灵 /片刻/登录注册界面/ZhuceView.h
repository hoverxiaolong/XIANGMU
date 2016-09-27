//
//  ZhuceView.h
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^ZhuceTap)();
@interface ZhuceView : UIView
@property (nonatomic,copy) ZhuceTap block;
//昵称
@property (strong, nonatomic) UILabel *nichengLabel;
@property (strong, nonatomic) UITextField *nichengTextfiled;
@property (strong, nonatomic) UILabel *nichengLineLabel;
//用户名
@property (strong, nonatomic) UILabel *EmailLabel;
@property (strong, nonatomic) UITextField *EmailTextfiled;
@property (strong, nonatomic) UILabel *EmailLineLabel;
//密码
@property (strong, nonatomic) UILabel *passwordLabel;
@property (strong, nonatomic) UITextField *passwordTextfiled;
@property (strong, nonatomic) UILabel *passwordLineLabel;
//完成按钮
@property (strong, nonatomic) UIButton *OverButton;
//说明
@property (strong, nonatomic) UILabel *shuomingLabel;

//- (void)zhuceButtonHaveTap;

@end
