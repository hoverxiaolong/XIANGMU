//
//  SlipHeaderView.m
//  UStory
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "SlipHeaderView.h"
@interface SlipHeaderView ()
{
    __weak UILabel *_labUserName;
}
@end

@implementation SlipHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (void)loadDefaultSetting{
    CGFloat width = ScreenWidth - 100;
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"bg2.jpg"];
    [self addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self);
    }];
    
    /** 头像按钮 */
    UIButton *headImageBtn = [[UIButton alloc]init];
    [headImageBtn setImage:[UIImage imageNamed:@"headimage"] forState:UIControlStateNormal];
    headImageBtn.backgroundColor = randomColor;
    headImageBtn.tag = 100;
    [self addSubview:headImageBtn];
    headImageBtn.layer.cornerRadius = 40;
    headImageBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    headImageBtn.layer.borderWidth = 1.0;
    headImageBtn.layer.masksToBounds = YES;
    [headImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(width/2 - 40);
        make.top.equalTo(self).offset(20);
        make.width.height.mas_equalTo(80);
    }];
    [headImageBtn addTarget:self action:@selector(didTapSlipHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        /** 注册按钮 */
        UIButton *registBtn = [[UIButton alloc]init];
        registBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [registBtn setTitle:@"注\t册" forState:UIControlStateNormal];
        [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registBtn.tag = 101;
        [self addSubview:registBtn];
        [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(headImageBtn.mas_centerX).offset(-15);
            make.top.equalTo(headImageBtn.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        [registBtn addTarget:self action:@selector(didTapSlipHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        /** 登录按钮 */
        UIButton *loginBtn = [[UIButton alloc]init];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [loginBtn setTitle:@"登\t录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginBtn.tag = 102;
        [self addSubview:loginBtn];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(headImageBtn.mas_centerX).offset(15);
            make.top.equalTo(registBtn);
            make.height.mas_equalTo(20);
        }];
        [loginBtn addTarget:self action:@selector(didTapSlipHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(headImageBtn.mas_centerX).offset(-0.5);
            make.top.bottom.equalTo(registBtn);
            make.width.mas_equalTo(1);
        }];
}

- (void)didTapSlipHeaderBtn:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didTapSlipHeaderButtonWithTag:)]) {
        [self.delegate didTapSlipHeaderButtonWithTag:button.tag];
    }
}


@end
