//
//  AbstractDb.h
//  UStory
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface AbstractDb : NSObject

@property(nonatomic,strong)NSString *dbPath;//数据库文件路径
@property(nonatomic,strong)FMDatabaseQueue *queue;//数据库操作队列

- (id)init;

@end
