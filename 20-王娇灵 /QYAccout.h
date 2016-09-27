//
//  QYAccout.h
//  美物心语
//
//  Created by qingyun on 16/8/26.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYAccout : NSObject

@property (nonatomic,strong) NSString *nicheng;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) UIImageView *image;

+ (instancetype)shareAccount;

- (void)saveLogin:(NSDictionary *)info;

- (void)logOut;

- (BOOL)isLogin;


@end
