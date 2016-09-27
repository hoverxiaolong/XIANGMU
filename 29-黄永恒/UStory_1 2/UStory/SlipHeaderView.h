//
//  SlipHeaderView.h
//  UStory
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SlipHeaderViewDelegate<NSObject>

- (void)didTapSlipHeaderButtonWithTag:(NSInteger)tag;

@end

@interface SlipHeaderView : UIView

@property(nonatomic,weak)id<SlipHeaderViewDelegate>delegate;

@end
