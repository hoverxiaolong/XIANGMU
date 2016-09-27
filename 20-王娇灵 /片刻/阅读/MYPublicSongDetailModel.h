//
//  MYPublicSongDetailModel.h
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface MYPublicSongDetailModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *song_id;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *album_title;
@property (nonatomic ,copy) NSString *pic_small;
@property (nonatomic) NSInteger num;
@property (nonatomic,strong) NSString *album_no;
@end
