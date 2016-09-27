//
//  VoiceRecordingView.h
//  Yueba
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceRecordingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;//显示分贝的大小

//更新分贝的内容(1-8)
-(void)updatePower:(NSInteger)power;

@end
