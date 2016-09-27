//
//  QYAudioRecorder.m
//  Yueba
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "QYAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface QYAudioRecorder ()

@property (nonatomic, strong)AVAudioRecorder *recorder;//录音对象
@property (nonatomic, strong)NSString *filePath;//文件的保存路径

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation QYAudioRecorder

-(void)prepareRecordWith:(NSString *)path{
    self.filePath = path;
   // NSLog(@"%@", path);
    NSError *error;
    //设置使用的方式,对其他应用录音或者播放声音的影响
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        //NSLog(@"%@",error);
    }
    
    //准备录音的参数, 格式,采样率,通道
    NSDictionary *settings = @{AVFormatIDKey:@(kAudioFormatMPEG4AAC), AVSampleRateKey:@16000,AVNumberOfChannelsKey:@1};
    
    //初始化录音对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:settings error:&error];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];//设置可以获取分贝
    //NSLog(@"%@", error);
    
    //开始录音
    [self.recorder record];
    
    //初始化刷新分贝的timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updatePowerValue:) userInfo:nil repeats:YES];
    
}

//暂停录音
-(void)pauseRecorder{
    if (self.recorder.recording){
        [self.recorder pause];
    }
    //暂停timer,把timer的触发事件挪到以后
    [self.timer setFireDate:[NSDate distantFuture]];
    
    
}

//恢复录音
-(void)continueRecorder{
    if (!self.recorder.recording) {
        [self.recorder record];
    }
    //把timer的触发时间设置到之前
    [self.timer setFireDate:[NSDate distantPast]];
}

//结束录音

-(void)stopRecorder{
    
    [self.recorder stop];
    
    //恢复其它应用被打断的录音或者播放声音
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    [self.timer invalidate];
}

-(void)cancelRecorder{
    [self.recorder stop];
    //恢复其它应用被打断的录音或者播放声音
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:&error];
    [self.timer invalidate];
}

-(void)updatePowerValue:(NSTimer *)timer{
    _timeInterval = self.recorder.currentTime;
    //更新分贝
    [self.recorder updateMeters];
    //去当前分贝值
    CGFloat peakPower = [self.recorder averagePowerForChannel:0];
    //NSLog(@"%f", peakPower);
    
    //把-60作为最小分贝
    CGFloat minPower = -60;
    peakPower = peakPower < minPower ? minPower : peakPower;
    
//    区间为60
    CGFloat range = -minPower;
    //分为8个档次
    float index = (peakPower + range)/(range/8);
    
    int result = (int)index;
    result = result == 0 ? 1 : result;
    
    if (self.powerValue) {
        self.powerValue(result);
    }
}

@end
