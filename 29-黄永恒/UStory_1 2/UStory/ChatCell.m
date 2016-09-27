//
//  ChatCell.m
//  UStory
//
//  Created by qingyun on 16/9/16.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import "ChatCell.h"
#import <AVOSCloudIM.h>

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *originImage = self.bgImage.image;
    //设置可缩放图片
    UIImage *image = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 23, 15, 23)];
    self.bgImage.image = image;
    
    //设置label可以显示的最大宽度
    self.contentLabel.preferredMaxLayoutWidth = ScreenWidth - 65 - 80;
}

- (void)BindMessages:(AVIMTypedMessage *)message{
    self.contentLabel.text = message.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
