//
//  MyXuanCell.m
//  LuyinBofang
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MyXuanCell.h"
#import <AVOSCloudIM.h>
#import "Masonry.h"
#import <AVOSCloud/AVOSCloud.h>
#import "JXLDayAndNightMode.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface MyXuanCell ()

@property (nonatomic,strong) NSMutableArray *timeArray;
@property (nonatomic,strong) NSString *username;

@end

@implementation MyXuanCell

- (void)awakeFromNib {
    [super awakeFromNib];
       
    self.icon.layer.cornerRadius = 20;
    self.icon.layer.masksToBounds = YES;
    //设置背景图片
    UIImage *originImage = self.bgImage.image;
    //设置为可以缩放的图片
    UIImage *image = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(17, 23, 18, 24)];
    self.bgImage.image = image;
    
    //label预计显示最大宽度
    self.contentLabel.preferredMaxLayoutWidth = kScreenWidth - 66 - 80;
    self.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    [self sheZhiNightDay];
}



- (void)sheZhiNightDay {
    
    [self jxl_setDayMode:^(UIView *view) {
        
        MyXuanCell *cell = (MyXuanCell *)view;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentLabel.textColor = [UIColor blackColor];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        
    } nightMode:^(UIView *view) {
        
        MyXuanCell *cell = (MyXuanCell *)view;
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.contentLabel.textColor = [UIColor blackColor];
        
        cell.contentView.backgroundColor = [UIColor blackColor];

    }];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    
    if (self.sharebtn) {
        self.sharebtn();
    }
}

- (IBAction)recodeShareBtn:(UIButton *)sender {
    
    if (self.shareBtnRecode) {
        self.shareBtnRecode();
    }
}


- (void)bandingMessage:(AVIMTypedMessage *)message {
    
    if ([message isKindOfClass:[AVIMTextMessage class]]) {
        NSAttributedString *attr = [self faceAttributedStringWithMessage:message.text Attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        
        self.contentLabel.attributedText = attr;
        
    }else if ([message isKindOfClass:[AVIMAudioMessage class]]){
        AVIMAudioMessage *mess = (AVIMAudioMessage *)message;
        //设置录音时间
        self.contentLabel.text = [NSString stringWithFormat:@"%@s", mess.text];
        //判断cell的类型
        if ([self.reuseIdentifier isEqualToString:@"audio"]) {
            self.animationImage.animationImages = @[[UIImage imageNamed:@"ReceiverVoiceNodePlaying000"],[UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],[UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],[UIImage imageNamed:@"ReceiverVoiceNodePlaying003"]];
        }
        //音频的长度
        NSInteger duration = mess.text.integerValue;
        NSInteger maxLength =kScreenWidth - 160;
        NSInteger minLength = 50;
        NSInteger avage = maxLength / 15;//现实的长途最大20s
        NSInteger length = avage * duration;
        
        //限制长度
        length = maxLength < length ? maxLength : length;
        length = minLength > length ? minLength : length;
        [_bgImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(length);
        }];
        
        _animationImage.animationDuration = 1;
        _animationImage.animationRepeatCount = duration;
        
    }

}

//根据文字内容替换为表情字符转
-(NSAttributedString *)faceAttributedStringWithMessage:(NSString *)message Attributes:(NSDictionary *)attribute{
    
    //    将message替换为可变属性字符串
    NSMutableAttributedString *messageAttri = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
    
    //将图片转化为富文本
    //读取表情文件,遍历数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"plist"];
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *tt = result[@"TT"];
    [tt enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建文本附件(图片)
        NSTextAttachment *atta = [[NSTextAttachment alloc] init];
        atta.image = [UIImage imageNamed:obj[@"imgName"]];
        atta.bounds = CGRectMake(0, 0, 16, 16);
        //转化为属性字符
        NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:atta];
        
        //需要替换的文字的搜索区域
        NSRange searchRange = NSMakeRange(0, messageAttri.length);
        //找到的表情所在的区域
        NSRange resultRange;
        //查找要替换的字符串
        NSString *faceStr = obj[@"faceName"];
        while (searchRange.length != 0) {
            resultRange = [messageAttri.string rangeOfString:faceStr options:0 range:searchRange];
            if (resultRange.length != 0) {
                //将制定位置,替换为表情富文本
                [messageAttri replaceCharactersInRange:resultRange withAttributedString:imageText];
                //延后产找区域,注意替换后字符串变短的问题
                NSInteger index = NSMaxRange(resultRange) -(faceStr.length  - 1);
                searchRange = NSMakeRange(index, messageAttri.length  - index);
            }else{
                //                如果没有找到
                searchRange.length = 0;
            }
            
        }
        
    }];
    
    
    //用富文本替换掉表情对应的字符
    
    return messageAttri;
}



@end
