//
//  MainDiaryView.h
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainDiaryViewDelegate <NSObject>

- (void)didSelectDiaryItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)pan;

@end

@interface MainDiaryView : UIView

@property(nonatomic,weak)id<MainDiaryViewDelegate>diaryDelegate;

@property(nonatomic,strong)NSMutableArray *arrDiaryModel;

@end
