//
//  SlipTitltView.m
//  UStory
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "SlipTitleView.h"

@implementation SlipTitleView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:75/255.0 green:184/255.0 blue:126/255.0 alpha:1];
        /** 返回按钮 */
        UIButton *backBtn = [[UIButton alloc]init];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.top.equalTo(self).offset(10);
            make.width.height.mas_equalTo(20);
        }];
        [backBtn addTarget:self action:@selector(didTapBackBtn) forControlEvents:UIControlEventTouchUpInside];
        
        /** 标题 */
        UILabel *labTitle = [[UILabel alloc]init];
        labTitle.text = title;
        labTitle.font = [UIFont systemFontOfSize:16];
        labTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labTitle];
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
            make.leading.equalTo(self.mas_centerX).offset(-100);
        }];
    }
    return self;
}

- (void)didTapBackBtn{
    if (self.blkDidTapBackBtn) {
        self.blkDidTapBackBtn();
    }
}


@end
