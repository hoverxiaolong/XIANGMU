//
//  MYPublicSonglistModel.m
//  Little
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "MYPublicSonglistModel.h"

@implementation MYPublicSonglistModel
+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"pic_500",@"listenum",@"collectnum",@"desc",@"title",@"tag",@"content",@"pic_radio",@"publishtime",@"info",@"author"];
}
@end
