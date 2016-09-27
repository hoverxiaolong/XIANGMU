//
//  AbstractDb.m
//  UStory
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "AbstractDb.h"

#define DB_FileName @"US.sqlite"

@implementation AbstractDb

- (id)init{
    if (self = [super init]) {
        NSString *strDoc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        self.dbPath = [strDoc stringByAppendingPathComponent:DB_FileName];
//        NSLog(@"数据库路径%@",self.dbPath);
    }
    return self;
}

@end
