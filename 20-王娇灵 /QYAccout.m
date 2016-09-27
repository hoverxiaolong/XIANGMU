//
//  QYAccout.m
//  美物心语
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "QYAccout.h"

#define kAccountFile @"accountFile"

@interface QYAccout ()<NSCoding>

@end

@implementation QYAccout

+ (instancetype)shareAccount {
    
    static QYAccout *account;
    //单例的block
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        //归档的文件路径
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:kAccountFile];
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (!account) {
            
            //如果解档失败
            account = [[QYAccout alloc] init];
        }
        
    });
    return account;
}

- (void)saveLogin:(NSDictionary *)info {
    
    self.username = info[@"username"];
    self.nicheng = info[@"nicheng"];
    self.image = info[@"image"];
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:kAccountFile];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

//判断是否登录
- (BOOL)isLogin {
    
    if (self.username) {
        return YES;
    }else{
        return NO;
    }
}


//解档的delegate
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.nicheng = [aDecoder decodeObjectForKey:@"nicheng"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
}

//归档的delegate
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.nicheng forKey:@"nicheng"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

- (void)logOut {
    
    //清除内存
    //清除归档文件
    
    self.username = nil;
    NSError *error;
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:kAccountFile];
    
    //NSLog(@"%@",filePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isok = [fileMgr removeItemAtPath:filePath error:&error];
    if (isok) {
        //NSLog(@"删除文件");
    }else{
        //NSLog(@"删除失败");
        //NSLog(@"%@",error.localizedDescription);
    }
   
}


@end
