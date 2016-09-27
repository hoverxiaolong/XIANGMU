//
//  DiaoduControllerDispatch.h
//  心情语录
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiaoduControllerDispatch : NSObject

//决定究竟加载哪个界面(唯一调用此类的入口)
+ (void)createViewControllerWithIndex:(NSUInteger)index;





@end
