//
//  MYPlayingViewController.h
//  Little
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYMusicModel;
@protocol playingViewControllerDelegate <NSObject>
@optional
- (void)updateIndicatorViewOfVisisbleCells;
@end
@interface MYPlayingViewController : UIViewController
@property (nonatomic ,weak) id<playingViewControllerDelegate> delegate;
@property (nonatomic ,strong) MYMusicModel *currentMusic;

@property (nonatomic,assign) NSInteger tagRow;


+ (instancetype)sharePlayingVC;
- (void)setSongIdArray:(NSMutableArray *)array currentIndex:(NSInteger)index;
- (void)clickIndicator;
@end
