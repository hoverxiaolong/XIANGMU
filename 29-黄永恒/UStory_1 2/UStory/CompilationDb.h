//
//  CompilationDb.h
//  UStory
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "AbstractDb.h"
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "CompilationModel.h"
#import "DiaryModel.h"

@interface CompilationDb : AbstractDb

+ (id)shareInstance;

- (void)Insert:(CompilationModel *)compilationModel;

- (void)Delete:(NSInteger)cId;

- (void)Resave:(NSInteger)cId Info:(CompilationModel *)compilationModel;

//查询指定记录
-(NSMutableArray *)queryBy:(NSString *)ctitle;

- (NSMutableArray *)queryWith:(NSInteger)cId;

-(NSMutableArray *)Query;

@property(nonatomic,copy)void(^blkUpdataDiary)();

@end
