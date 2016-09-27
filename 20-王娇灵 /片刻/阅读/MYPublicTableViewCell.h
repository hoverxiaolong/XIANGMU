//
//  MYPublicTableViewCell.h
//  美物心语
//
//  Created by qingyun on 16/9/2.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NAKPlaybackIndicatorView.h>
@class MYPublicSongDetailModel,MYPublicTableViewCell;
@protocol PublicTableViewCellDelegate <NSObject>
- (void)clickButton:(UIButton *)button openMenuOfCell:(MYPublicTableViewCell *)cell;
- (void)clickCellMenuItemAtIndex:(NSInteger)index Cell:(MYPublicTableViewCell *)cell;
- (void)clickIndicatorView;
@end
@interface MYPublicTableViewCell : UITableViewCell
@property (nonatomic ,weak) id<PublicTableViewCellDelegate> delegate;
@property (nonatomic) BOOL isOpenMenu;
@property (nonatomic) BOOL bePic;
@property (nonatomic ,weak) UIButton *menuButton;
@property (nonatomic) NAKPlaybackIndicatorViewState indicatorViewState;
@property (nonatomic ,weak) MYPublicSongDetailModel *detailModel;
- (void)setUpCellMenu;
+ (instancetype)publicTableViewCellcellWithTableView:(UITableView *)tableView;
@end
