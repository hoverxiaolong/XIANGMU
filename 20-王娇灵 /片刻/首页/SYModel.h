//
//  SYModel.h
//  美物心语
//
//  Created by qingyun on 16/8/30.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
#define SYNameFont [UIFont systemFontOfSize:14]
#define SYContentFont [UIFont systemFontOfSize:16]


@interface SYModel : NSObject
//标题
@property (nonatomic,strong) NSString *name;

//头像
@property (nonatomic,strong) NSString *icon;

//正文
@property (nonatomic,strong) NSString *content;

//配图
@property (nonatomic,strong) NSString *picture;

//会员
@property (nonatomic,assign,getter=isVip) BOOL vip;

//底部的工具条
@property (nonatomic,weak) UIView *bottomView;

//cell的分割线
@property (nonatomic,weak) UIView *devier;

//构造方法
- (instancetype)initWithDictionary:(NSDictionary *)dictData;

+ (instancetype) shouWithDictionary:(NSDictionary *)dictData;

@end
