//
//  NewDiaryHeaderView.h
//  UStory
//
//  Created by qingyun on 16/9/6.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewDiaryViewDelegate<NSObject>

- (void)SaveNewDiary;

@end

@interface NewDiaryHeaderView : UIView

@property(nonatomic,copy)void(^blkCancelBtn)();
@property(nonatomic,weak)id<NewDiaryViewDelegate>delegate;

@end
