//
//  MYMusicModel.m
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYMusicModel.h"

@implementation MYMusicModel
+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"songName",@"artistName",@"albumName",@"songPicSmall",@"songPicBig",@"songPicRadio",@"songLink",@"lrcLink",@"showLink",@"songId"];
}
@end
