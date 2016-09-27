//
//  ChooseGenderView.m
//  UStory
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ChooseGenderView.h"
#import "GenderBtn.h"

@implementation ChooseGenderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (void)loadDefaultSetting{
    
    UILabel *labSex = [[UILabel alloc]init];
    labSex.text = @"选择性别";
    labSex.font = [UIFont systemFontOfSize:15];
    labSex.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labSex];
    [labSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    
    GenderBtn *boy = [[GenderBtn alloc]init];
    [boy setImage:[UIImage imageNamed:@"boy"] forState:UIControlStateNormal];
    [boy setTitle:@"男" forState:UIControlStateNormal];
    [boy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    boy.tag = 520;
    [self addSubview:boy];
    [boy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(40);
        make.top.equalTo(labSex.mas_bottom).offset(30);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(65);
    }];
    [boy addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchUpInside];
    
    GenderBtn *girl = [[GenderBtn alloc]init];
    [girl setImage:[UIImage imageNamed:@"girl"] forState:UIControlStateNormal];
    [girl setTitle:@"女" forState:UIControlStateNormal];
    [girl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    girl.tag = 521;
    [self addSubview:girl];
    [girl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-40);
        make.top.equalTo(labSex.mas_bottom).offset(30);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(65);
    }];
    [girl addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chooseGender:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(ChooseGenderWithTag:Gender:)]) {
        [self.delegate ChooseGenderWithTag:button.tag Gender:button.titleLabel.text];
    }
}

@end
