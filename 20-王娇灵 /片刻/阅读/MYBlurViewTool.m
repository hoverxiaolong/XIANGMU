//
//  MYBlurViewTool.m
//  美物心语
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYBlurViewTool.h"

@implementation MYBlurViewTool
+ (void)blurView:(UIView *)view style:(UIBarStyle)style
{
    UIToolbar *blurView = [[UIToolbar alloc] init];
    blurView.barStyle = style;
    blurView.frame = view.frame;
    [view addSubview:blurView];
}
@end
