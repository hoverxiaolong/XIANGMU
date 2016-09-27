//
//  SlipLoginHeader.m
//  UStory
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "SlipLoginHeader.h"
@interface SlipLoginHeader ()
{
    __weak UILabel *_labUserName;
}
@end
@implementation SlipLoginHeader

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
    headImageBtn.backgroundColor = randomColor;
    [headImageBtn setImage:[UIImage imageNamed:@"headimage"] forState:UIControlStateNormal];
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
    [headImageBtn addTarget:self action:@selector(didTapSlipLoginHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [userDefault dataForKey:@"usersHeaderImage"];
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil) {
        [headImageBtn setImage:[UIImage imageNamed:@"headimage"] forState:UIControlStateNormal];
    }else{
        [headImageBtn setImage:image forState:UIControlStateNormal];
    }
    
    UILabel *labUserName = [[UILabel alloc]init];
    labUserName.font = [UIFont systemFontOfSize:15];
    labUserName.textColor = [UIColor whiteColor];
    labUserName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labUserName];
    [labUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headImageBtn);
        make.top.equalTo(headImageBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(150);
    }];
    _labUserName = labUserName;
}

- (void)setStrUserName:(NSString *)strUserName{
    _strUserName = strUserName;
    _labUserName.text = strUserName;
}

- (void)didTapSlipLoginHeaderBtn:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(LoginHeaderView)]) {
        [self.delegate LoginHeaderView];
    }
}

@end
