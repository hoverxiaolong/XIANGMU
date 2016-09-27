//
//  QYAudioPlayer.m
//  Yueba
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface QYAudioPlayer()<AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioPlayer *audioPlayer;

@end

@implementation QYAudioPlayer

+(instancetype)sharePalyer{
    static QYAudioPlayer *palyer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        palyer = [[QYAudioPlayer alloc] init];
    });
    return palyer;
}

-(void)playerAudioWith:(NSData *)data{
    //设置播放声音
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //清空播放器
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.audioPlayer.delegate = self;
    [_audioPlayer play];
    
}

-(void)pause{
    [_audioPlayer pause];
}

-(void)stopPlay{
    [_audioPlayer stop];
    //唤醒其他被打断的
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

#pragma mark player delegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //唤醒其他被打断的
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

@end
