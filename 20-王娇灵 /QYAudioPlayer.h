//
//  QYAudioPlayer.h
//  Yueba
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYAudioPlayer : NSObject

+(instancetype)sharePalyer;

//播放生音
-(void)playerAudioWith:(NSData *)data;
//暂停
-(void)pause;
//结束
-(void)stopPlay;

@end
