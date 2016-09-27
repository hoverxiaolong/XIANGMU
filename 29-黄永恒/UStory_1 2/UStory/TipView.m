
//
//  TipView.m
//  UStory
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 黄永恒. All rights reserved.
//  消息提示视图

#import "TipView.h"

@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Time:(NSTimeInterval)time{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *labTip = [[UILabel alloc]init];
        labTip.frame = self.bounds;
        labTip.text = title;
        labTip.numberOfLines = 0;
        labTip.textAlignment = NSTextAlignmentCenter;
        labTip.font = [UIFont systemFontOfSize:14];
        [self addSubview:labTip];
        [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(selfRemove) userInfo:nil repeats:NO];
    }
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    return self;
}

- (void)selfRemove{
    [self removeFromSuperview];
    if (self.blkTipView) {
        self.blkTipView();
    }
}



@end
