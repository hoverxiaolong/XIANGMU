//
//  SQLHandler.m
//  
//
//  Created by 唐立春 on 16/7/1.
//  Copyright © 2016年 TangLiChun. All rights reserved.
//

#import "SQLHandler.h"
#import "MYPublicSongDetailModel.h"


@implementation SQLHandler

+ (SQLHandler *)shareInstance {
    static SQLHandler *handler = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        handler = [[SQLHandler alloc] init];
        [handler openDB];
        [handler createTable];
    });
    return handler;
}

- (void)openDB {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dbPath = [docPath stringByAppendingString:@"/test.db"];
    int result = sqlite3_open([dbPath UTF8String], &DBPoint);
    if (result == SQLITE_OK) {
        //NSLog(@"打开成功: %@", dbPath);
    } else {
        //NSLog(@"打开失败");
    }
}

- (void)createTable {
    NSString *createSql = [NSString stringWithFormat:@"create table musicModel (song_id integer primary key, title text, pic_small text)"];
    int result = sqlite3_exec(DBPoint, [createSql UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        //NSLog(@"创建成功");
    } else {
        //NSLog(@"创建失败");
    }
}

- (void)insert:(MYPublicSongDetailModel *)musicModel {
    NSString *insertSql = [NSString stringWithFormat:@"insert into musicModel values (%ld, '%@', '%@')", (long)[musicModel.song_id integerValue], musicModel.title, musicModel.pic_small];
    int result = sqlite3_exec(DBPoint, [insertSql UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        //NSLog(@"添加成功");
    } else {
       // NSLog(@"添加失败");
    }
}


- (NSMutableArray *)selectAll {
    // 1. 创建一个状态指针
    // stmt 相当于一个零食的数据库, 负责暂时保存 sql 的执行结果, 在结束时集中对数据库进行写入
    sqlite3_stmt *stmt = nil;
    // 2. 写 sql 语句
    NSString *selectSql = @"select * from musicModel";
    // 3. 执行 sql 语句, 检查 sql 格式, 将结果保存在 stmt 指针中
    // 参数3: 限制语句的长度, -1表示不限制
    // 参数4: stmt 指针的地址
    int result = sqlite3_prepare_v2(DBPoint, [selectSql UTF8String], -1, &stmt, NULL);
    // 创建一个空数组, 为了稍后添加 student 对象
    NSMutableArray *mArr = [NSMutableArray array];
    if (result == SQLITE_OK) {
        // sqlite3_step(stmt) 执行一次取出一行数据, 知道最后一条数据为止
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 对每一行的数据进行分解, 获取
            
            // 按列获取数据
            // 参数2: 第几列
            int ID = sqlite3_column_int(stmt, 0);
            
            const unsigned char *title = sqlite3_column_text(stmt, 1);
            
            const unsigned char *medium = sqlite3_column_text(stmt, 2);
            // 使用上面的数据创建 student 的对象, 放到数组中
            MYPublicSongDetailModel *movie = [[MYPublicSongDetailModel alloc] init];
            
            movie.song_id = [[NSString alloc] initWithFormat:@"%d", ID];
            movie.title = [NSString stringWithUTF8String:(char *)title];
            movie.pic_small = [NSString stringWithUTF8String:(char *)medium];
            [mArr addObject:movie];
            
        }
    }
    // 销毁 stmt 指针, 回收内存, 将变化写入本地数据库.
    sqlite3_finalize(stmt);
    return mArr;
}

- (void)delete:(MYPublicSongDetailModel *)musicModel {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from musicModel where title = '%@'", musicModel.title];
    int result = sqlite3_exec(DBPoint, [deleteSql UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        //NSLog(@"删除成功");
    } else {
       // NSLog(@"删除失败");
    }
}


@end
