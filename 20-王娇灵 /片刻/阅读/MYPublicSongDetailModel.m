//
//  MYPublicSongDetailModel.m
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYPublicSongDetailModel.h"
#import <MJExtension/NSObject+MJKeyValue.h>

@implementation MYPublicSongDetailModel

+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"title",@"song_id",@"author",@"album_title",@"pic_small"];
}
@end
