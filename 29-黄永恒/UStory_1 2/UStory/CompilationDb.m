//
//  CompilationDb.m
//  UStory
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "CompilationDb.h"

#define DB_FileName @"US.sqlite"

@implementation CompilationDb

+ (id)shareInstance{
    static CompilationDb *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedInstance = [[CompilationDb alloc]init];
    });
    return sharedInstance;
}

- (id)init{
    if (self = [super init]) {
        [self initDB];
    }
    return self;
}

- (void)initDB{
    self.queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.queue inDatabase:^(FMDatabase *db) {
                NSString *sql = @"CREATE TABLE if not exists compilationinfor (cId integer PRIMARY KEY AUTOINCREMENT,ctitle text,cdescribe text,coverImage text)";
                if ([db executeUpdate:sql]) {
                    NSLog(@"故事集数据库初始化成功");
                }else{
                    NSLog(@"数据库初始化失败");
                }
            }];
        });
}

#pragma mark - ▷ 添加 ◁
- (void)Insert:(CompilationModel *)compilationModel{
    NSString *strSql = [NSString stringWithFormat:@"insert into compilationinfor(cID,ctitle,cdescribe,coverImage) values(%ld,\"%@\",\"%@\",\"%@\")",(long)compilationModel.cId,compilationModel.ctitle,compilationModel.cdescribe,compilationModel.coverImage];
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:strSql]) {
            NSLog(@"故事集插入成功");
        }else{
            NSLog(@"故事集插入失败");
        }
    }];
}

#pragma mark - ▷ 删除 ◁
- (void)Delete:(NSInteger)cId{
    NSString *strSql=[NSString stringWithFormat:@"delete from compilationinfor where cId=%ld",(long)cId];
    [self.queue inDatabase:^(FMDatabase *db){
        if ([db executeUpdate:strSql]) {
            NSLog(@"删除成功");
        }
    }];
}

#pragma mark - ▷ 更新 ◁
- (void)Resave:(NSInteger)cId Info:(CompilationModel *)compilationModel{
    NSString *strSql=[NSString stringWithFormat:@"update compilationinfor set ctitle=\"%@\",cdescribe=\"%@\",coverImage=\"%@\" where cId=%ld ",compilationModel.ctitle,compilationModel.cdescribe,compilationModel.coverImage,(long)cId];
    [self.queue inDatabase:^(FMDatabase *db){
        if ([db executeUpdate:strSql]) {
            NSLog(@"故事集更新成功");
        }else{
            NSLog(@"故事集更新失败");
        }
    }];
}
//
//- (void)Updata:(NSInteger)cId{
//    NSString *strSql = [NSString stringWithFormat:@"updata compilationinfor inner join diaryinfor on compilationinfor.ctitle = diaryinfor.dtitle"]
//}

#pragma mark - ▷ 指定条件查询 ◁
- (NSMutableArray *)queryBy:(NSString *)ctitle{
    NSMutableArray *dataArr=[NSMutableArray array];
    FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        //1.sql语句
        NSString *sql=[NSString stringWithFormat:@"select * from compilationinfor where ctitle=\'%@\'",ctitle];
        FMResultSet *set =[db executeQuery:sql];
        while ([set next]) {
            NSDictionary *dict=[set resultDictionary];
            CompilationModel *model=[[CompilationModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [dataArr addObject:model];
        }
    }
    [db close];
    return dataArr;
}

#pragma mark - ▷ 按cid查找 ◁
- (NSMutableArray *)queryWith:(NSInteger)cId{
    NSMutableArray *dataMuArr = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *strSql = [NSString stringWithFormat:@"select * from compilationinfor where cId=%ld",(long)cId];
        FMResultSet *set =[db executeQuery:strSql];
        while ([set next]) {
            NSDictionary *dict=[set resultDictionary];
            CompilationModel *model=[[CompilationModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [dataMuArr addObject:model];
        }
    }
    [db close];
    return dataMuArr;
}

- (NSMutableArray *)Query{
    NSMutableArray *mArr=[NSMutableArray array];
    //初始化数据库
    FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
    //打开数据库
    if ([db open]) {
        NSString *strSql=@"SELECT * FROM compilationinfor;";
        FMResultSet *rs =[db executeQuery:strSql];
        while ([rs next]) {
            //kvc的方式 字典=>模型
            NSDictionary *dict=[rs resultDictionary];
            CompilationModel *compilationModel=[[CompilationModel alloc] init];
            [compilationModel setValuesForKeysWithDictionary:dict];
            [mArr addObject:compilationModel];
        }
    }
    //关闭数据库
    [db close];
    
    return mArr;
}

@end
