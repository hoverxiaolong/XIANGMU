//
//  DiaoduControllerDispatch.m
//  心情语录
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "DiaoduControllerDispatch.h"
#import "MyMusicViewController.h"
#import "ShezhiViewController.h"
#import "BaseViewController.h"
#import "ShouyeViewController.h"
#import "ShoucangViewController.h"
#import "RecordVC.h"
#import "MyNavigationVC.h"


@implementation DiaoduControllerDispatch
#pragma mark - 调度方法
+ (void)createViewControllerWithIndex:(NSUInteger)index
{
    
    DiaoduControllerDispatch *dispatchTool = [DiaoduControllerDispatch shareOpenController];
    
    //用当前类的对象 执行实际选择执行方法
    [dispatchTool openViewControllerWithIndex:index];
    
    
}

+ (instancetype)shareOpenController
{
    //获取到调度的唯一对象
    static DiaoduControllerDispatch *tempTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        tempTool = [[DiaoduControllerDispatch alloc] init];
    });
    return tempTool;
}

#pragma mark - 实际执行方法
- (void)openViewControllerWithIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            static BaseViewController *navVC = nil;
            
            ShouyeViewController *shouyeVC = [[ShouyeViewController alloc] init];
                            navVC = [[BaseViewController alloc] initWithRootViewController:shouyeVC];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }
            break;
        case 1:
        {
            static BaseViewController *navVC = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken,^{
                ShoucangViewController *radioVC = [[ShoucangViewController alloc] init];
                navVC = [[BaseViewController alloc] initWithRootViewController:radioVC];
            });
            
            [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
            
            break;
        case 2:
//         [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
//        }
        {
            
            static BaseViewController *navVC = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken,^{
                RecordVC *shequVC = [[RecordVC alloc] init];
                navVC = [[BaseViewController alloc] initWithRootViewController:shequVC];
            });
            
            [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }
            break;
        
        case 3:
       
        {
            static MyNavigationVC *navVC = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken,^{
                MyMusicViewController *readVC = [[MyMusicViewController alloc] init];
                navVC = [[MyNavigationVC alloc] initWithRootViewController:readVC];
            });
            
            [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }
            break;

        
        case 4:
        {
            static BaseViewController *navVC = nil;
            //static dispatch_once_t onceToken;
//            dispatch_once(&onceToken,^{
                ShezhiViewController *shezhiVC = [[ShezhiViewController alloc] init];
                navVC = [[BaseViewController alloc] initWithRootViewController:shezhiVC];
            //});
            
            [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }
            break;
            
            
        default:
            break;
    }
    
}

}

@end

    


