//
//  EmailLoginView.h
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^LoginButton)();

@interface EmailLoginView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) LoginButton blockLogin;
//用户名label
@property (strong, nonatomic) UILabel *userLabel;
//用户名textfiled
@property (strong, nonatomic) UITextField *userTextfiled;
//用户名下横线
@property (strong, nonatomic) UILabel *userLineLabel;
//密码label
@property (strong, nonatomic) UILabel *passwordLabel;
//密码textfiled
@property (strong, nonatomic) UITextField *passwordTextfiled;
//密码下横线
@property (strong, nonatomic) UILabel *passwordLineLabel;
//登录按钮
@property (strong, nonatomic) UIButton *LoadingButton;

@end
