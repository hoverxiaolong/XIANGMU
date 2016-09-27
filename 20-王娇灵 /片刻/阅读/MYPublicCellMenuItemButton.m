//
//  MYPublicCellMenuItemButton.m
//  Little
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "MYPublicCellMenuItemButton.h"
#import "MYPublicCellIconModel.h"
#define HCSmallFont [UIFont systemFontOfSize:10.0]
#define HColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HCMainColor HColor(252,12,68)

@implementation MYPublicCellMenuItemButton
- (instancetype)initWithFrame:(CGRect)frame model:(MYPublicCellIconModel *)model
{
    if (self = [super initWithFrame:frame]) {
        [self settingItemButtonWithModel:model];
    }
    return self;
}
- (void)settingItemButtonWithModel:(MYPublicCellIconModel *)model
{
    //图片
    UIImageView *image = [[UIImageView alloc] init];
    image.bounds = CGRectMake(0, 0, 20, 20);
    image.center = CGPointMake(self.frame.size.width/2, 20);
    image.image = [UIImage imageNamed:model.icon];
    [self addSubview:image];
    
    //文案
    UILabel *title = [[UILabel alloc] init];
    title.bounds = CGRectMake(0, 0, self.frame.size.width, 20);
    title.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - title.frame.size.height/2+ 4);
    title.text = model.title;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = HCSmallFont;
    title.textColor = HCMainColor;
    [self addSubview:title];
}
@end
