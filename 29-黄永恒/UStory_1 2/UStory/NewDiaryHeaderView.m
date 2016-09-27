//
//  NewDiaryHeaderView.m
//  UStory
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "NewDiaryHeaderView.h"

@implementation NewDiaryHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (void)loadDefaultSetting{
    UIButton *btnCancel = [[UIButton alloc]init];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    [btnCancel addTarget:self action:@selector(didTapCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnCertain = [[UIButton alloc]init];
    [btnCertain setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCertain setTitle:@"保存" forState:UIControlStateNormal];
    btnCertain.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:btnCertain];
    [btnCertain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(50);
    }];
    [btnCertain addTarget:self action:@selector(didTapCertainBtn) forControlEvents:UIControlEventTouchUpInside];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *formatString = @"yy-MM-dd HH:mm";
    formatter.dateFormat = formatString;
    NSString *strTime = [formatter stringFromDate:date];
    
    UILabel *labTime = [[UILabel alloc]init];
    labTime.numberOfLines = 0;
    labTime.textAlignment = NSTextAlignmentCenter;
    labTime.font = [UIFont systemFontOfSize:13];
    labTime.text = strTime;
    [self addSubview:labTime];
    [labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self);
        make.width.mas_equalTo(60);
    }];
}

- (void)didTapCancelBtn{
    if (self.blkCancelBtn) {
        self.blkCancelBtn();
    }
}

- (void)didTapCertainBtn{
    if ([self.delegate respondsToSelector:@selector(SaveNewDiary)]) {
        [self.delegate SaveNewDiary];
    }
}


@end
