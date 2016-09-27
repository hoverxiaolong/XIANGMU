//
//  MYPromptTool.h
//  Little
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface MYPromptTool : NSObject
+ (void)promptModeText:(NSString *)text afterDelay:(NSInteger)time;
+ (MBProgressHUD *)promptModeIndeterminatetext:(NSString *)text;
@end
