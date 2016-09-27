//
//  MainHeadView.h
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainHeadViewDelegate<NSObject>

- (void)didTapSearchBtn;
- (void)didTapSideslipBtn;

@end

@interface MainHeadView : UIView

@property(nonatomic,copy)void (^blkDidChooseBtnAtIndex)(NSUInteger index);

@property(nonatomic,weak)id<MainHeadViewDelegate>headViewDelegate;

-(void)chooseIndex:(NSInteger)index;

@end
