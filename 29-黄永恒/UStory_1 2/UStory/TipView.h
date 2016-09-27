//
//  TipView.h
//  UStory
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipView : UIView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Time:(NSTimeInterval)time;

@property(nonatomic,copy)void(^blkTipView)();

@end
