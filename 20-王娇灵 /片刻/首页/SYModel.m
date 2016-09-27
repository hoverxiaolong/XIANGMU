//
//  SYModel.m
//  美物心语
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "SYModel.h"

@implementation SYModel

//构造方法的实现
- (instancetype)initWithDictionary:(NSDictionary *)dictData {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dictData];
    }
    return self;
}

+ (instancetype)shouWithDictionary:(NSDictionary *)dictData {
    
    return [[self alloc] initWithDictionary:dictData];
}

@end
