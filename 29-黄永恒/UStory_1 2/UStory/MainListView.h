//
//  MainListView.h
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainListViewDelegate <NSObject>

- (void)didSelectListItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didTapCreatCompilationBtn;

@end

@interface MainListView : UIView

@property(nonatomic,weak)id<MainListViewDelegate>collectionDelegate;

@end
