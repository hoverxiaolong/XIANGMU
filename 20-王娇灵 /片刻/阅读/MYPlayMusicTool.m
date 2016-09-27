//
//  MYPlayMusicTool.m
//  美物心语
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYPlayMusicTool.h"
#import <NAKPlaybackIndicatorView.h>
#import <AVFoundation/AVFoundation.h>
#import "MYMusicIndicator.h"

#import "MYPlayerQueue.h"
@interface MYPlayMusicTool()
@end
@implementation MYPlayMusicTool: NSObject
static MYMusicIndicator *_indicator;
static NSMutableDictionary *_playingMusic;
+ (void)initialize
{
    _playingMusic = [NSMutableDictionary dictionary];
    _indicator = [MYMusicIndicator shareIndicator];
}
+ (void)setUpCurrentPlayingTime:(CMTime)time link:(NSString *)link
{
    AVPlayerItem *playItem = _playingMusic[link];
    MYPlayerQueue *queue = [MYPlayerQueue sharePlayerQueue];
    [playItem seekToTime:time completionHandler:^(BOOL finished) {
        [_playingMusic setObject:playItem forKey:link];
        [queue play];
        _indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    }];
}
+ (AVPlayerItem *)playMusicWithLink:(NSString *)link
{
    MYPlayerQueue *queue = [MYPlayerQueue sharePlayerQueue];
    AVPlayerItem *playItem = _playingMusic[link];
    if (!playItem) {
        playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:link]];
        [_playingMusic setObject:playItem forKey:link];
        [queue replaceCurrentItemWithPlayerItem:playItem];
    }
    [queue play];
    _indicator.state = NAKPlaybackIndicatorViewStatePlaying;
    return playItem;
}

+ (void)pauseMusicWithLink:(NSString *)link
{
    AVPlayerItem *playItem = _playingMusic[link];
    if (playItem) {
        MYPlayerQueue *queue = [MYPlayerQueue sharePlayerQueue];
        [queue pause];
        _indicator.state = NAKPlaybackIndicatorViewStatePaused;
    }
}

+ (void)stopMusicWithLink:(NSString *)link
{
    AVPlayerItem *playItem = _playingMusic[link];
    if (playItem) {
        MYPlayerQueue *queue = [MYPlayerQueue sharePlayerQueue];
        [_playingMusic removeAllObjects];
        [queue removeItem:playItem];
    }
}
@end
