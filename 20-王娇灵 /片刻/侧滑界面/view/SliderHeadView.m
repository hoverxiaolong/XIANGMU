//
//  SliderHeadView.m
//  心情语录
//
//  Created by qingyun on 16/8/18.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "SliderHeadView.h"
#import "Masonry.h"
#import "LoadViewController.h"

@implementation SliderHeadView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    
        self = [super initWithFrame:frame];
        if (self) {
            [self addSubview:self.backgroundImage];
            [self addSubview:self.headImageButton];
            [self addSubview:self.userNameButton];
            [self addAutoLayout];

        }
    return self;
}



- (void)addAutoLayout
{
    //防止循环引用
    WS(weakSelf);
    //侧边栏headerView的背景图
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(110);
    }];
    
    [_headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(40);
        make.left.equalTo(weakSelf.mas_left).offset(30);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
     [_userNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(weakSelf.headImageButton.mas_right).offset(10);
         make.centerY.equalTo(weakSelf.headImageButton.mas_centerY);
    
     }];
    

}

#pragma mark - 懒加载
- (UIImageView*)backgroundImage
{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        [_backgroundImage setBackgroundColor:[UIColor yellowColor]];
    }
    return _backgroundImage;
}
- (UIButton*)headImageButton
{
    if (!_headImageButton) {
        _headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headImageButton setBackgroundColor:[UIColor clearColor]];
        [_headImageButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
    }
    return _headImageButton;
}
- (UIButton*)userNameButton
{
    
    if (!_userNameButton) {
        
        
            _userNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [_userNameButton setTitle:@"登录/注册" forState:UIControlStateNormal];
            [_userNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
    }
    
    return _userNameButton;
}


@end
