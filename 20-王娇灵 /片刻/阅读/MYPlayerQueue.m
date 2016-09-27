//
//  MYPlayerQueue.m
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYPlayerQueue.h"

@implementation MYPlayerQueue
static id _playerQueue;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerQueue = [super allocWithZone:zone];
    });
    return _playerQueue;
}

+ (instancetype)sharePlayerQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerQueue = [[self alloc] init];
    });
    return _playerQueue;
}
@end
