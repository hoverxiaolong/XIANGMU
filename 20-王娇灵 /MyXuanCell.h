//
//  MyXuanCell.h
//  LuyinBofang
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVIMTypedMessage;
typedef void(^ShareBtn)();
typedef void(^ShareBtnRecode)();


@interface MyXuanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIImageView *animationImage;

@property (nonatomic,copy) NSString *time;

@property (weak, nonatomic) IBOutlet UIButton *share;

@property (nonatomic,strong) ShareBtn sharebtn;
@property (nonatomic,strong) ShareBtnRecode shareBtnRecode;
@property (weak, nonatomic) IBOutlet UIButton *recodeShare;

- (void)bandingMessage:(AVIMTypedMessage *)message;

@end
