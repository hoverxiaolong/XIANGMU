//
//  DiaryModel.m
//  UStory
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "DiaryModel.h"

@implementation DiaryModel

-(void) setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"未定义属性%@",key);
}

@end
