//
//  VoiceRecordingView.m
//  Yueba
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "VoiceRecordingView.h"

@implementation VoiceRecordingView


-(void)updatePower:(NSInteger)power{
    //NSLog(@"%ld", (long)power);
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"RecordingSignal00%ld", (long)power]];
}

@end
