//
//  ChatCell.h
//  UStory
//
//  Created by qingyun on 16/9/16.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVIMTypedMessage;

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

- (void)BindMessages:(AVIMTypedMessage *)message;

@end
