//
//  HCRankListModel.m
//  美物心语
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 bjsxt. All rights reserved.
//



#import "HCRankListModel.h"

@implementation HCRankListModel
+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"count",@"web_url",@"pic_s192",@"pic_s210"];
}
@end
