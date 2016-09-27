//
//  GenderBtn.m
//  UStory
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "GenderBtn.h"

@implementation GenderBtn


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
}

#pragma mark - ▶ button图片自定义布局 ◀
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rectImage = CGRectMake(0, 0, 40, 40);
    return rectImage;
}

#pragma mark - ▶ button标题自定义布局 ◀
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectMake(0,40,40,25);
    return rectTitle;
}

@end
