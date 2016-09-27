//
//  CompilationModel.m
//  UStory
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CompilationModel.h"

@implementation CompilationModel

-(void) setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"未定义属性%@",key);
}

@end
