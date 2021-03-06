//
//  MYMusicModel.h
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MYMusicModel : NSObject
@property (nonatomic ,copy) NSString *songName;
@property (nonatomic ,copy) NSString *artistName;
@property (nonatomic ,copy) NSString *albumName;
@property (nonatomic ,copy) NSString *songPicSmall;
@property (nonatomic ,copy) NSString *songPicBig;
@property (nonatomic ,copy) NSString *songPicRadio;
@property (nonatomic ,copy) NSString *songLink;
@property (nonatomic ,copy) NSString *lrcLink;
//更高品质
@property (nonatomic ,copy) NSString *showLink;
@property (nonatomic ,copy) NSString *songId;
@end
