//
//  DiaryDb.h
//  UStory
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 黄永恒. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AbstractDb.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "DiaryModel.h"

@interface DiaryDb : AbstractDb

+ (id)shareInstance;

- (void)Insert:(DiaryModel *)diaryModel;

- (void)Delete:(NSInteger)dId;

- (void)Updata:(NSInteger)dId Info:(DiaryModel *)dMode;

//查询指定记录
-(NSMutableArray *)queryBy:(NSString *)dclass;

- (NSMutableArray *)queryWith:(NSInteger)equalId;

-(NSMutableArray *)Query;

@end
