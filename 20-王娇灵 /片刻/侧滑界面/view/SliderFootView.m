//
//  SliderFootView.m
//  心情语录
//
//  Created by qingyun on 16/8/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "SliderFootView.h"
#import "Masonry.h"

@implementation SliderFootView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.changpianButton];
        [self addSubview:self.bigLabel];
        [self addSubview:self.smallLabel];
        [self addSubview:self.stopButton];
        
        [self addAutoLayout];
    }
    
    return  self;
    
}


- (void)addAutoLayout
{
    WS(weakSelf);
    
    [_changpianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.size.equalTo(CGSizeMake(45, 45));
    }];
    
    [_bigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.changpianButton.mas_right).offset(10);
        make.top.equalTo(weakSelf.mas_top).offset(15);
        make.size.equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.45, 30));
    }];
    
    [_smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.changpianButton.mas_right).offset(10);
        make.top.equalTo(weakSelf.bigLabel.mas_bottom).offset(10);
        make.size.equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.3, 20));
    }];
    
    [_stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-15);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.equalTo(CGSizeMake(20, 20));
        
    }];
}





#pragma mark - 懒加载
- (UIButton*)changpianButton
{
    if (!_changpianButton) {
        _changpianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changpianButton setBackgroundColor:[UIColor clearColor]];
        [_changpianButton setImage:[UIImage imageNamed:@"唱片"] forState:UIControlStateNormal];
        [_changpianButton addTarget:self action:@selector(gotoChangpian) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changpianButton;
}

- (void)gotoChangpian
{
    
    
}

- (UILabel*)bigLabel
{
    if (!_bigLabel) {
        _bigLabel = [[UILabel alloc] init];
        _bigLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    return  _bigLabel;
}

- (UILabel*)smallLabel
{
    if (!_smallLabel) {
        _smallLabel = [[UILabel alloc] init];
        _smallLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _smallLabel;
}

- (UIButton*)stopButton
{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopButton.backgroundColor = [UIColor clearColor];
        [_stopButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _stopButton;
    
}

- (void)stopMethod
{
    if (![_stopButton.imageView.image  isEqual: [UIImage imageNamed:@"暂停"]]) {

    [_stopButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }
    else
    {
        [_stopButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}



@end
