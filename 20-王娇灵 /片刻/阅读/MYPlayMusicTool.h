//
//  MYPlayMusicTool.h
//  美物心语
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class HCPlayerQueue;
@interface MYPlayMusicTool : NSObject

+ (AVPlayerItem *)playMusicWithLink:(NSString *)link;

+ (void)pauseMusicWithLink:(NSString *)link;

+ (void)stopMusicWithLink:(NSString *)link;

+ (void)setUpCurrentPlayingTime:(CMTime)time link:(NSString *)link;
@end
