//
//  RecodeBar.h
//  LuyinBofang
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GotoLogin)();

//输入栏的两种状态
typedef enum : NSUInteger {
    kRecodeBarText,
    kRecodeBarSound,
    kRecodeBarFaces
    
} RecodeBarStatus;

#define kChartBarHeight 35

@protocol RecodeBarDelegate <NSObject>

- (void)senMessage:(id)message;

@end

@interface RecodeBar : UIView

@property (weak, nonatomic) IBOutlet UIButton *talkButton;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (nonatomic,weak) id <RecodeBarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *facesButton;
@property (nonatomic,copy) GotoLogin login;
@property (nonatomic) RecodeBarStatus status;
- (void)logOut;
@end
