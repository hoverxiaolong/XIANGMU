//
//  DiaryToolView.m
//  UStory
//
//  Created by 黄永恒 on 16/8/20.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "DiaryToolView.h"
#import "ToolButtonView.h"

@implementation DiaryToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
    
    NSArray *arrTitleNames = @[@"返回",@"编辑",@"删除",@"专辑"];
    NSArray *arrImages = @[@"return",@"edit",@"delete",@"compilation"];
    CGFloat width = ScreenWidth/4;
    for (NSUInteger index = 0; index<4; index++) {
        ToolButtonView *button = [[ToolButtonView alloc]init];
        [button setImage:[UIImage imageNamed:arrImages[index]] forState:UIControlStateNormal];
        [button setTitle:arrTitleNames[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:button];
        button.tag = index + 10;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(index * width);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(width);
        }];
        
        [button addTarget:self action:@selector(tapToolButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)tapToolButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didTapToolBtnWithTag:)]) {
        [self.delegate didTapToolBtnWithTag:button.tag];
    }
}


@end
