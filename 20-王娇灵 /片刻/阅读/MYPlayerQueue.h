//
//  MYPlayerQueue.h
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>

@interface MYPlayerQueue : AVQueuePlayer
+ (instancetype)sharePlayerQueue;
@end
