//
//  ZhuceView.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ZhuceView.h"
#import "Masonry.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoadViewController.h"


@implementation ZhuceView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.nichengLabel];
//        [self addSubview:self.nichengTextfiled];
//        [self addSubview:self.nichengLineLabel];
        
        [self addSubview:self.EmailLabel];
        [self addSubview:self.EmailTextfiled];
        [self addSubview:self.EmailLineLabel];
        
        [self addSubview:self.passwordLabel];
        [self addSubview:self.passwordTextfiled];
        [self addSubview:self.passwordLineLabel];
        
        [self addSubview:self.OverButton];
        [self addSubview:self.shuomingLabel];
        
        [self AddAutoLayout];
        
    }
    
    return self;
    
}

- (void)AddAutoLayout
{
    
    WS(weakSelf);
    //昵称约束
//    [_nichengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.1);
//        make.top.equalTo(weakSelf.mas_top).offset(20);
//        make.width.equalTo(80);
//    }];
//    
//    [_nichengTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.nichengLabel.mas_right).offset(10);
//        make.centerY.equalTo(weakSelf.nichengLabel.mas_centerY);
//        make.right.equalTo(weakSelf.mas_right).offset(-[UIScreen mainScreen].bounds.size.width * 0.1);
//    }];
//    
//    [_nichengLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.1);
//        make.right.equalTo(weakSelf.mas_right).offset(-[UIScreen mainScreen].bounds.size.width * 0.1);
//        make.top.equalTo(weakSelf.nichengTextfiled.mas_bottom).offset(5);
//        make.height.equalTo(1);
//    }];
    
    //邮箱约束
    [_EmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.1);
                make.top.equalTo(weakSelf.mas_top).offset(20);
                make.width.equalTo(80);
            }];
    [_EmailTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.EmailLabel.mas_right).offset(10);
                make.centerY.equalTo(weakSelf.EmailLabel.mas_centerY);
                make.right.equalTo(weakSelf.mas_right).offset(-[UIScreen mainScreen].bounds.size.width * 0.1);
    }];
    
    [_EmailLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
                make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.1);
                make.right.equalTo(weakSelf.mas_right).offset(-[UIScreen mainScreen].bounds.size.width * 0.1);
                make.top.equalTo(weakSelf.EmailTextfiled.mas_bottom).offset(5);
                make.height.equalTo(1);
    }];
    
    
    //密码约束
    [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.EmailLabel.mas_centerX);
        make.top.equalTo(weakSelf.EmailLineLabel.mas_bottom).offset(20);
        make.width.equalTo(80);
    }];
    [_passwordTextfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_EmailTextfiled.mas_centerX);
        make.centerY.equalTo(weakSelf.passwordLabel.mas_centerY);
        make.left.equalTo(weakSelf.passwordLabel.mas_right).offset(10);
    }];
    
    [_passwordLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.passwordTextfiled.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.1);
        make.height.equalTo(1);
    }];
    
    
    
    [_OverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.1);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.passwordLineLabel.mas_bottom).offset(30);
        make.height.equalTo([UIScreen mainScreen].bounds.size.height * 0.06);
    }];
    
    [_shuomingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.15);
        make.right.equalTo(weakSelf.mas_right).offset(-[UIScreen mainScreen].bounds.size.width * 0.4);
        make.top.equalTo(weakSelf.OverButton.mas_bottom).offset([UIScreen mainScreen].bounds.size.height * 0.04);
        make.height.equalTo(20);
        
    }];
    
}




#pragma mark - 懒加载
////昵称懒加载
//- (UILabel*)nichengLabel
//{
//    if (!_nichengLabel) {
//        _nichengLabel = [[UILabel alloc]init];
//        _nichengLabel.text = @"昵称:";
//   
//    }
//    return _nichengLabel;
//}
//
//- (UITextField*)nichengTextfiled
//{
//    if (!_nichengTextfiled) {
//        _nichengTextfiled = [[UITextField alloc] init];
//  
//      
//        
//    }
//    return _nichengTextfiled;
//}
//
//- (UILabel*)nichengLineLabel
//{
//    if (!_nichengLineLabel) {
//        _nichengLineLabel = [[UILabel alloc] init];
//        _nichengLineLabel.backgroundColor = [UIColor blackColor];
//    }
//    return _nichengLineLabel;
//}
//
//邮箱懒加载
- (UILabel*)EmailLabel
{
    if (!_EmailLabel) {
        _EmailLabel = [[UILabel alloc] init];
        _EmailLabel.text = @"用户名:";
     
    }
    
    return  _EmailLabel;
}

- (UITextField*)EmailTextfiled
{
    if (!_EmailTextfiled) {
        _EmailTextfiled = [[UITextField alloc]init];
       
       
    }
    
    return _EmailTextfiled;
}

- (UILabel*)EmailLineLabel
{
    if (!_EmailLineLabel) {
        _EmailLineLabel = [[UILabel alloc] init];
        _EmailLineLabel.backgroundColor = [UIColor blackColor];
    }
    
    return _EmailLineLabel;
}


//密码懒加载
- (UILabel*)passwordLabel
{
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"密码:";
       
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


- (UIButton*)OverButton
{
    if (!_OverButton) {
        _OverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_OverButton setTitle:@"完成" forState:UIControlStateNormal];
        [_OverButton setBackgroundColor:[UIColor colorWithRed:116/255.0 green:160/255.0 blue:55/255.0 alpha:1.0f]];
        [_OverButton addTarget:self action:@selector(OverMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _OverButton;
}

- (void)OverMethod
{
    
    if (self.block) {
        
        self.block();
    }

    
}


@end
