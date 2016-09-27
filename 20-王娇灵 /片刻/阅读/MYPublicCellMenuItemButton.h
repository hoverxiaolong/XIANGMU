//
//  MYPublicCellMenuItemButton.h
//  Little
//
//  Created by huangcong on 16/4/23.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYPublicCellIconModel;
@interface MYPublicCellMenuItemButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame model:(MYPublicCellIconModel *)iconModel;
@end
