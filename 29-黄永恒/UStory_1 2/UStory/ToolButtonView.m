//
//  ToolButtonView.m
//  UStory
//
//  Created by 黄永恒 on 16/8/22.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ToolButtonView.h"

@implementation ToolButtonView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

-(void)loadDefaultSetting{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - ▶ button图片自定义布局 ◀
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rectImage = CGRectMake(CGRectGetWidth(contentRect)/2 - 10, 6, 18, 18);
    return rectImage;
}

#pragma mark - ▶ button标题自定义布局 ◀
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectMake(0, 30, CGRectGetWidth(contentRect), 10);
    return rectTitle;
}

@end
