//
//  EmailLoginView.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "EmailLoginView.h"
#import "Masonry.h"
@implementation EmailLoginView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.EmailLabel];
        [self addSubview:self.EmailTextfiled];
        [self addSubview:self.EmailLineLabel];
        [self addSubview:self.passwordLabel];
        [self addSubview:self.passwordTextfiled];
        [self addSubview:self.passwordLineLabel];
        [self addSubview:self.LoadingButton];
        
       
        
        [self addAutouLayout];
        
    }
    return self;
    
}
#pragma mark - 屏幕适配
- (void)addAutouLayout
{
    WS(weakSelf);
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(30);
        make.width.equalTo(80);
        make.top.equalTo(weakSelf.mas_top).offset(20);
        
    }];
    
    [_userTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.EmailLabel.mas_centerY);
        make.left.equalTo(weakSelf.EmailLabel.mas_right).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-30);
    }];
    
    [_userLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.EmailLabel.mas_top).offset(25);
        make.left.equalTo(weakSelf.mas_left).offset(25);
        make.right.equalTo(weakSelf.mas_right).offset(-30);
        make.height.equalTo(1);
    }];
    
    [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.EmailLabel.mas_top).offset(40);
        make.width.equalTo(80);
        make.left.equalTo(weakSelf.mas_left).offset(30);
    }];
    
    [_passwordTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.passwordLabel.mas_centerY);
        make.centerX.equalTo(weakSelf.EmailTextfiled.mas_centerX);
        make.right.equalTo(weakSelf.mas_right).offset(-30);
    }];
    
    [_passwordLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.EmailLineLabel.mas_top).offset(40);
        make.centerX.equalTo(weakSelf.EmailLineLabel.mas_centerX);
        make.right.equalTo(weakSelf.mas_right).offset(-30);
        make.height.equalTo(1);
    }];
    
    [_LoadingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwordLineLabel.mas_top).offset(20);
        make.centerX.equalTo(weakSelf.passwordLineLabel.mas_centerX);
        make.right.equalTo(weakSelf.mas_right).offset(-30);
        make.height.equalTo(40);
    }];
    
    
}



#pragma mark  - 懒加载

- (UILabel*)EmailLabel
{
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] init];
        _userLabel.text = @"用户名:";
        _userLabel.textAlignment = NSTextAlignmentCenter;
        _userLabel.font = [UIFont systemFontOfSize:15];
      
    }
    return _userLabel;
}
- (UITextField*)EmailTextfiled
{
    if (!_userTextfiled) {
        _userTextfiled = [[UITextField alloc] init];
     
   
        
    }
    
    return _userTextfiled;
}

- (UILabel*)EmailLineLabel
{
    if (!_userLineLabel) {
        _userLineLabel = [[UILabel alloc] init];
        _userLineLabel.backgroundColor = [UIColor blackColor];
    }
    return _userLineLabel;
}
- (UILabel*)passwordLabel
{
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"密码:";
        _passwordLabel.textAlignment = NSTextAlignmentCenter;
        _passwordLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _passwordLabel;
}
- (UITextField*)passwordTextfiled
{
    if (!_passwordTextfiled) {
        _passwordTextfiled = [[UITextField alloc] init];
        
    }
    
    return _passwordTextfiled;
}

- (UILabel*)passwordLineLabel
{
    if (!_passwordLineLabel) {
        _passwordLineLabel = [[UILabel alloc] init];
        _passwordLineLabel.backgroundColor = [UIColor blackColor];
    }
    return _passwordLineLabel;
}

- (UIButton*)LoadingButton
{
    if (!_LoadingButton) {
        _LoadingButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_LoadingButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:160/255.0 blue:55/255.0 alpha:1.0f]];
        [_LoadingButton setTitle:@"登录" forState:UIControlStateNormal];
        _LoadingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_LoadingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_LoadingButton addTarget:self action:@selector(gotoLoad) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _LoadingButton;
}
- (void)gotoLoad
{
    if (self.blockLogin) {
        self.blockLogin();
    }
}




@end
