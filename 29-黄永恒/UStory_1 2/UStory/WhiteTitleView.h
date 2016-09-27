//
//  WhiteTitleView.h
//  UStory
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhiteTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property(nonatomic,copy)void(^blkDidTapBackBtn)();
@property(nonatomic,strong)UILabel *labTitle;

@end
