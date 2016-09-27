//
//  RecodeBar.m
//  LuyinBofang
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RecodeBar.h"
#import "Masonry.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "FacesKeyboard.h"
#import "FaceModel.h"
#import <AVOSCloud/AVOSCloud.h>
#import "VoiceRecordingView.h"
#import "QYAudioRecorder.h"
#import "QYAccout.h"
#import "LXAlertView.h"
#import "MyXuanCell.h"

@interface RecodeBar ()<UITextViewDelegate>

@property (nonatomic,strong) VoiceRecordingView *recordingView;//显示录音状态的View
@property (nonatomic, strong)FacesKeyboard *facesKeyboard;
@property (nonatomic, strong)NSMutableArray *inputFaces;//已经输入的表情
@property (nonatomic, strong)QYAudioRecorder *audioRecorder;//录音对象


@end

@implementation RecodeBar

//初始化
- (void)awakeFromNib {
    
    [self.sendButton addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.textView.delegate = self;
    [self changeStatus:kRecodeBarText];
    //初始化表情容器
    self.inputFaces = [NSMutableArray array];
    
    [self.speakButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self.speakButton addTarget:self action:@selector(touchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self.speakButton addTarget:self action:@selector(touchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.speakButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.speakButton addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];

}

//发送按钮

- (void)rightButtonPress:(id)sender {
    
    if (![QYAccout shareAccount].isLogin) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录哦" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
    }else if ((self.status == kRecodeBarText || self.status == kRecodeBarFaces ) && self.textView.text != nil && self.textView.text.length != 0) {
        
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        
        AVObject *mess = [AVObject objectWithClassName:@"Message"];
        [mess setObject:username forKey:@"myname"];
        [mess setObject:self.textView.text forKey:@"textview"];
        
        [mess saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //NSLog(@"保存成功");
            }else{
                //NSLog(@"%@",error);
            }
        }];
        
        [self sendMessage:nil];
    }
}

- (void)logOut {
    
    if (self.login) {
        self.login();
    }
}


//根据修改的状态调整UI
-(void)changeStatus:(RecodeBarStatus)status{
    self.status = status;
    switch (status) {
        case kRecodeBarText:
        {
            self.speakButton.hidden = YES;
            self.textView.inputView = nil;
            if ([self.textView isFirstResponder]) {
                [self.textView reloadInputViews];
            }else{
                
                [self.textView becomeFirstResponder];
            }
            [self.talkButton setImage:[UIImage imageNamed:@"messageBar_Microphone"] forState:UIControlStateNormal];
            [self.facesButton setImage:[UIImage imageNamed:@"messageBar_Smiley"] forState:UIControlStateNormal];
            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [self.sendButton setImage:nil forState:UIControlStateNormal];
            
        }
            break;
            
        case kRecodeBarSound:
        {
            self.speakButton.hidden = NO;
            self.textView.inputView = nil;
            [self.textView resignFirstResponder];
            [self.talkButton setImage:[UIImage imageNamed:@"messageBar_Keyboard"] forState:UIControlStateNormal];
            [self.facesButton setImage:[UIImage imageNamed:@"messageBar_Smiley"] forState:UIControlStateNormal];
            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [self.sendButton setImage:nil forState:UIControlStateNormal];
            
        }
            break;
        case kRecodeBarFaces:
        {
            self.speakButton.hidden = YES;
            //切换键盘
            self.facesKeyboard = [[[NSBundle mainBundle] loadNibNamed:@"FaceKeyboard" owner:nil options:nil] firstObject];
            //初始化回调block
            __weak RecodeBar *recodeBar = self;
            [self.facesKeyboard setSelectedFace:^(FaceModel *model){
                [recodeBar selectedFace:model];
            }];
            self.textView.inputView = self.facesKeyboard;
            
            //            已经是第一相应,切换键盘
            if ([self.textView isFirstResponder]) {
                [self.textView reloadInputViews];
            }else{
                [self.textView becomeFirstResponder];
            }
            
            [self.talkButton setImage:[UIImage imageNamed:@"messageBar_Microphone"] forState:UIControlStateNormal];
            [self.facesButton setImage:[UIImage imageNamed:@"messageBar_Keyboard"] forState:UIControlStateNormal];
            
            [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [self.sendButton setImage:nil forState:UIControlStateNormal];
        }
            break;

        
        default:
            break;
    }
    
}

-(void)selectedFace:(FaceModel *)face{
    //处理表情
    //NSLog(@"%@", face);
    //空表情不处理
    if (face.isBlack){
        return;
    }
    
    if (!face.isBack) {
        self.textView.text = [self.textView.text stringByAppendingString:face.text];
        [self.inputFaces addObject:face];
    }else{
        //选择的是删除按钮
        if (self.inputFaces.count == 0) {
            return;
        }
        //取出最后一个表情
        FaceModel *model = self.inputFaces.lastObject;
        //找到所在的位置
        NSRange range = [self.textView.text rangeOfString:model.text options:NSBackwardsSearch];
        //替换掉内容
        self.textView.text = [self.textView.text stringByReplacingCharactersInRange:range withString:@""];
        [self.inputFaces removeLastObject];
    }
    [self textViewDidChange:_textView];
    [self changeSelfHeight];
}

-(QYAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        _audioRecorder = [[QYAudioRecorder alloc] init];
        __weak RecodeBar *chartBar = self;
        [_audioRecorder setPowerValue:^(NSInteger power){
            [chartBar.recordingView updatePower:power];
        }];
        
    }
    return _audioRecorder;
}

-(VoiceRecordingView *)recordingView{
    if (!_recordingView) {
        _recordingView = [[[NSBundle mainBundle] loadNibNamed:@"VoiceRecordingView" owner:nil options:nil] firstObject];
        
        //        设置显示的位置
        _recordingView.center = self.superview.center;
    }
    return _recordingView;
}


//点击声音按钮改变状态
- (IBAction)soundButtonPress:(id)sender {
    //根据现有状态,修改状态
    if (self.status == kRecodeBarSound) {
        [self changeStatus:kRecodeBarText];
    }else{
        [self changeStatus:kRecodeBarSound];
    }
}

- (IBAction)faceButtonPress:(id)sender {
    
    if (self.status == kRecodeBarFaces) {
        [self changeStatus:kRecodeBarText];
    }else{
        [self changeStatus:kRecodeBarFaces];
    }

}

#pragma mark - text View delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    //根据文字的改变调整高度
    
    if (self.textView.text.length != 0) {
        [self changeSelfHeight];
        [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendButton setImage:nil forState:UIControlStateNormal];
    }
}

- (void)changeSelfHeight {
    
    //textview内容的高度和文字的高度一样
    CGSize size = self.textView.contentSize;
    //限制一个最大高度和最小高度
    CGFloat maxHeight = 150;
    CGFloat minHeight = kChartBarHeight;
    
    CGFloat height = size.height;
    height = height > maxHeight ? maxHeight : height;
    height = height < minHeight ? minHeight :height;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(height);
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //如果发现输入的是回车符号
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage:nil];
        return NO;
    }
    return YES;
}


- (void)sendMessage:(UIButton *)button {
    
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.textView.text attributes:nil];
    [self.delegate senMessage:message];
    self.textView.text = nil;
    [self changeSelfHeight];
    //发送完,改变右边图片的状态
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self. sendButton setImage:nil forState:UIControlStateNormal];
}

#pragma mark - recorder action

-(void)touchDown:(UIButton *)button{
    //NSLog(@"touchDown");//开始录音
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myTemp.aac"];
    [self.audioRecorder prepareRecordWith:path];
    [self.superview addSubview:self.recordingView];
}

-(void)touchDragEnter:(UIButton *)button{
   // NSLog(@"touchDragEnter");//继续录音
    //因为录音文件不需要持久保存,使用临时文件夹
    [self.audioRecorder continueRecorder];
}

-(void)touchDragExit:(UIButton *)button{
    //NSLog(@"touchDragExit");//暂停录音
    [self.audioRecorder pauseRecorder];
}

-(void)touchUpInside:(UIButton *)button{
    //NSLog(@"touchUpInside");//完成录音
    [self.audioRecorder stopRecorder];
    [self.recordingView removeFromSuperview];
    
    //准备发送录音
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"myTemp.aac"];
    AVFile *file = [AVFile fileWithName:@"myTemp.aac" contentsAtPath:path];
    AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:[NSString stringWithFormat:@"%d", (int)self.audioRecorder.timeInterval] file:file attributes:nil];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    file.ownerId = username;
    
    //保存录音
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //NSLog(@"录音保存成功");
        }else{
            //NSLog(@"%@",error);
        }
        
    }];
    

    [self.delegate senMessage:message];
    
}

-(void)touchUpOutside:(UIButton *)button{
    //NSLog(@"touchUpOutside");//取消录音
    [self.audioRecorder cancelRecorder];
    [self.recordingView removeFromSuperview];
}

@end
