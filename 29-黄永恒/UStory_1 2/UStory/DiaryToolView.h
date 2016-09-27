//
//  DiaryToolView.h
//  UStory
//
//  Created by 黄永恒 on 16/8/20.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DiaryToolViewDelegate <NSObject>

- (void)didTapToolBtnWithTag:(NSInteger)tag;

@end

@interface DiaryToolView : UIView

@property(nonatomic,weak)id<DiaryToolViewDelegate>delegate;

@end
