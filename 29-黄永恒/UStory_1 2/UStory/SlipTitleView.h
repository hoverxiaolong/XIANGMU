//
//  SlipTitltView.h
//  UStory
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlipTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property(nonatomic,copy)void(^blkDidTapBackBtn)();

@end
