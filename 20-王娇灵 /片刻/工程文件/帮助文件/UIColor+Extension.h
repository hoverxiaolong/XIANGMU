//
//  UIColor+Extension.h
//  美物心语
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 bjsxt. All rights reserved.
//#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
