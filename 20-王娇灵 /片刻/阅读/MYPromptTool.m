//
//  MYPromptTool.m
//  Little
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "MYPromptTool.h"
#import <MBProgressHUD.h>
@implementation MYPromptTool
+ (MBProgressHUD *)promptMode:(MBProgressHUDMode)mode text:(NSString *)text afterDelay:(NSInteger)time
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *prompt = [MBProgressHUD showHUDAddedTo:view animated:YES];
    prompt.userInteractionEnabled = NO;
    prompt.mode = mode;
    prompt.label.font = [UIFont systemFontOfSize:15];
    prompt.label.text = text;
    prompt.margin = 10.f;
    prompt.removeFromSuperViewOnHide = YES;
    [prompt hideAnimated:YES afterDelay:time];
    return prompt;
}
+ (void)promptModeText:(NSString *)text afterDelay:(NSInteger)time
{
    [self promptMode:MBProgressHUDModeText text:text afterDelay:time];
}

+ (MBProgressHUD *)promptModeIndeterminatetext:(NSString *)text
{
    return [self promptMode:MBProgressHUDModeIndeterminate text:text afterDelay:60];
}
@end
