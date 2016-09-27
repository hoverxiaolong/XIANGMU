//
//  DiaryDb.m
//  UStory
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "DiaryDb.h"

#define DB_FileName @"US.sqlite"

@implementation DiaryDb

+ (id)shareInstance{
    static DiaryDb *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedInstance = [[DiaryDb alloc]init];
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
                NSString *sql = @"CREATE TABLE if not exists diaryinfor (dId integer PRIMARY KEY,dtitle text,dtime text,dcontent text,dclass text,dequalId integer)";
                if ([db executeUpdate:sql]) {
                    NSLog(@"数据库初始化成功");
                }else{
                    NSLog(@"数据库初始化失败");
                }
            }];
        });
}

#pragma mark - ▷ 添加 ◁
- (void)Insert:(DiaryModel *)diaryModel{
    NSString *strSql = [NSString stringWithFormat:@"insert into diaryinfor(dId,dtitle,dtime,dcontent,dclass,dequalId) values(%ld,\"%@\",\"%@\",\"%@\",\"%@\",%ld)",(long)diaryModel.dId,diaryModel.dtitle,diaryModel.dtime,diaryModel.dcontent,diaryModel.dclass,(long)diaryModel.dequalId];
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:strSql]) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }];
}

#pragma mark - ▷ 删除 ◁
- (void)Delete:(NSInteger)dId{
    NSString *strSql=[NSString stringWithFormat:@"delete from diaryinfor where dId=%ld",(long)dId];
    [self.queue inDatabase:^(FMDatabase *db){
        if ([db executeUpdate:strSql]) {
            NSLog(@"日志删除成功");
        }
    }];
}

#pragma mark - ▷ 更新 ◁
- (void)Updata:(NSInteger)dId Info:(DiaryModel *)dModel{
    NSString *strSql=[NSString stringWithFormat:@"update diaryinfor set dtitle=\"%@\",dtime=\"%@\",dcontent=\"%@\",dclass=\"%@\",dequalId=%ld where dId=%ld ",dModel.dtitle,dModel.dtime,dModel.dcontent,dModel.dclass,(long)dModel.dequalId,(long)dId];
    [self.queue inDatabase:^(FMDatabase *db){
        if ([db executeUpdate:strSql]) {
            NSLog(@"日志更新成功");
        }else{
            NSLog(@"日志更新失败");
        }
    }];
}

#pragma mark - ▷ 指定条件查询 ◁
- (NSMutableArray *)queryBy:(NSString *)dclass{
    NSMutableArray *dataArr=[NSMutableArray array];
    FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        //1.sql语句
        NSString *sql=[NSString stringWithFormat:@"select * from diaryinfor where dclass=\'%@\'",dclass];
        FMResultSet *set =[db executeQuery:sql];
        while ([set next]) {
            NSDictionary *dict=[set resultDictionary];
            DiaryModel *diaryModal=[[DiaryModel alloc] init];
            [diaryModal setValuesForKeysWithDictionary:dict];
            [dataArr addObject:diaryModal];
        }
    }
    [db close];
    return dataArr;
}

#pragma mark - ▷ Id查询 ◁
- (NSMutableArray *)queryWith:(NSInteger)equalId{
    NSMutableArray *dataArr=[NSMutableArray array];
    FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        //1.sql语句
        NSString *sql=[NSString stringWithFormat:@"select * from diaryinfor where dequalId=%ld",(long)equalId];
        FMResultSet *set =[db executeQuery:sql];
        while ([set next]) {
            NSDictionary *dict=[set resultDictionary];
            DiaryModel *diaryModal=[[DiaryModel alloc] init];
            [diaryModal setValuesForKeysWithDictionary:dict];
            [dataArr addObject:diaryModal];
        }
    }
    [db close];
    return dataArr;
}

-(NSMutableArray *) Query{
    NSMutableArray *mArr=[NSMutableArray array];
    //初始化数据库
    FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
    //打开数据库
    if ([db open]) {
        NSString *strSql=@"SELECT * FROM diaryinfor;";
        FMResultSet *rs =[db executeQuery:strSql];
        while ([rs next]) {
            //kvc的方式 字典=>模型
            NSDictionary *dict=[rs resultDictionary];
            DiaryModel *diaryModal=[[DiaryModel alloc] init];
            [diaryModal setValuesForKeysWithDictionary:dict];
            [mArr addObject:diaryModal];
        }
    }
    //关闭数据库
    [db close];
    return mArr;
}
@end
