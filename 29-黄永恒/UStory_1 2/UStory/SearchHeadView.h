//
//  SearchHeadView.h
//  UStory
//
//  Created by 黄永恒 on 16/8/17.
//  Copyright © 2016年 黄永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchHeadViewDelegate<NSObject>

- (void)didTapBackBtn;

- (void)didTapSearchBtnWithText:(NSString *)searchText;

@end

@interface SearchHeadView : UIView

@property(nonatomic,weak)id<SearchHeadViewDelegate>searchViewDelegate;

@end
