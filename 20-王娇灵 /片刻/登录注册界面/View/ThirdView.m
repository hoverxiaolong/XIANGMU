//
//  ThirdView.m
//  心情语录
//
//  Created by qingyun on 16/8/20.
//  Copyright © 2016年 qingyun. All rights reserved.
//


#import "ThirdView.h"
#import "Masonry.h"
@implementation ThirdView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineOneLabel];
        [self addSubview:self.hezuoLabel];
        [self addSubview:self.lineTwoLabel];
        
        [self addSubview:self.sina];
        
        [self addSubview:self.qq];
        
        [self autoLayout];
    }
    
    
    return self;
    
}

- (void)autoLayout
{
    
    WS(weakSelf);
    
    [_lineOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(30);
        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width * 0.1);
        make.width.equalTo([UIScreen mainScreen].bounds.size.width * 0.2);
        make.height.equalTo(1);
    }];
    
    [_hezuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.lineOneLabel.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-[UIScreen mainScreen].bounds.size.width * 0.32);
        
    }];
    
    [_lineTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.hezuoLabel.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-[UIScreen mainScreen].bounds.size.width * 0.1);
        make.width.equalTo([UIScreen mainScreen].bounds.size.width * 0.2);
        make.height.equalTo(1);
    }];
    
    //两大平台约束
    [_sina mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.mas_left).offset([UIScreen mainScreen].bounds.size.width*0.3);
        make.top.equalTo(weakSelf.mas_top).offset([UIScreen mainScreen].bounds.size.height*0.1);
     
    }];
    

    [_qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.sina.mas_centerY);
        make.left.equalTo(weakSelf.sina.mas_right).offset([UIScreen mainScreen].bounds.size.width*0.35);
    }];
    
}


#pragma mark - 懒加载
- (UILabel*)lineOneLabel
{
    if (!_lineOneLabel) {
        _lineOneLabel = [[UILabel alloc] init];
        _lineOneLabel.backgroundColor = [UIColor blackColor];
    }
    return _lineOneLabel;
}

- (UILabel*)hezuoLabel
{
    if (!_hezuoLabel) {
        _hezuoLabel = [[UILabel alloc] init];
        _hezuoLabel.text = @"合作伙伴登录美物心语";
        _hezuoLabel.textColor = [UIColor blackColor];
        _hezuoLabel.textAlignment = NSTextAlignmentCenter;
        _hezuoLabel.font = [UIFont systemFontOfSize:15];
    }
    return _hezuoLabel;
}

- (UILabel*)lineTwoLabel
{
    if (!_lineTwoLabel) {
        _lineTwoLabel = [[UILabel alloc] init];
        _lineTwoLabel.backgroundColor = [UIColor blackColor];
    }
    return _lineTwoLabel;
}


- (UIButton*)sina
{
    if (!_sina) {
        _sina = [[UIButton alloc] init];
        [_sina setImage:[UIImage imageNamed:@"新浪"] forState:UIControlStateNormal];
        [_sina addTarget:self action:@selector(gotoSina) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sina;
}

- (UIButton*)qq
{
    if (!_qq) {
        _qq = [[UIButton alloc] init];
        [_qq setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        [_qq addTarget:self action:@selector(gotoQQ) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qq;
}

- (void)gotoSina {
    
    if (self.sinaBlock) {
        _sinaBlock();
    }
}

- (void)gotoQQ {
    
    if (self.qqBlock) {
        _qqBlock();
    }
}



@end
