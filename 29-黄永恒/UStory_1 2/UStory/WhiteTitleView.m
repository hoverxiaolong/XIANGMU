//
//  WhiteTitleView.m
//  UStory
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "WhiteTitleView.h"

@implementation WhiteTitleView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        /** 返回按钮 */
        UIButton *backBtn = [[UIButton alloc]init];
        [backBtn setImage:[UIImage imageNamed:@"whiteback"] forState:UIControlStateNormal];
        [self addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.top.equalTo(self).offset(10);
            make.width.height.mas_equalTo(20);
        }];
        [backBtn addTarget:self action:@selector(didTapBackBtn) forControlEvents:UIControlEventTouchUpInside];
        
        /** 标题 */
        self.labTitle = [[UILabel alloc]init];
        self.labTitle.text = title;
        self.labTitle.textColor = [UIColor whiteColor];
        self.labTitle.font = [UIFont systemFontOfSize:16];
        self.labTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.labTitle];
        [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
            make.leading.equalTo(self.mas_centerX).offset(-130);
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
