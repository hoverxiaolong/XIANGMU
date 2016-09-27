//
//  SQLHandler.h
//  
//
//  Created by 唐立春 on 16/7/1.
//  Copyright © 2016年 TangLiChun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class MYPublicSongDetailModel;

@interface SQLHandler : NSObject
{
    sqlite3 *DBPoint;
}

+ (SQLHandler *)shareInstance;

- (void)openDB;

- (void)createTable;

- (void)insert:(MYPublicSongDetailModel *)musicModel;

- (NSMutableArray *)selectAll;

- (void)delete:(MYPublicSongDetailModel *)musicModel;



@end
