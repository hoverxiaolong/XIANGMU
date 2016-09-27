//
//  QYAudioRecorder.h
//  Yueba
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
//声明block,通知分贝更新
typedef void (^UpdatePowerValue) (NSInteger power);

@interface QYAudioRecorder : NSObject

@property (nonatomic, copy)UpdatePowerValue powerValue;
@property (nonatomic)NSTimeInterval timeInterval;

//准备开始录音
-(void)prepareRecordWith:(NSString *)path;

//暂停
-(void)pauseRecorder;
//继续录音
-(void)continueRecorder;
//录音完成
-(void)stopRecorder;
//取消录音
-(void)cancelRecorder;

@end
