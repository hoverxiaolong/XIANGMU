//
//  MYPublicTableView.m
//  美物心语
//
//  Created by qingyun on 16/9/3.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "MYPublicTableView.h"
#import "MYPublicTableViewCell.h"
#import "MYPlayingViewController.h"
#import "MYMusicIndicator.h"
#import <NAKPlaybackIndicatorView.h>
#import "MYMusicModel.h"
#import "MYPublicSongDetailModel.h"
#import "MYPublicSonglistModel.h"
#import "MYPromptTool.h"
#import "JXLDayAndNightMode.h"

/*-----nslog-----*/

#ifdef DEBUG

#define HCLog(...) NSLog(__VA_ARGS__)

#else

#define HCLog(...)

#endif

#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

typedef NS_ENUM(NSInteger) {
    FavoriteItem = 0,

    DeleteItem = 1
}item;

@interface MYPublicTableView ()<UITableViewDelegate,UITableViewDataSource,PublicTableViewCellDelegate,playingViewControllerDelegate>
@property (nonatomic ,weak) MYPublicTableViewCell *isOpenCell;
@property (nonatomic ,strong) NSIndexPath *opendCellIndex;
@property (nonatomic ,assign) BOOL isOpen;

@property (nonatomic ,strong) NSMutableArray *songListArrayM;
@property (nonatomic ,strong) NSMutableArray *songIdsArrayM;
@property (nonatomic) NSInteger index1;
@end
@implementation MYPublicTableView
- (void)setSongList:(NSMutableArray *)list songIds:(NSMutableArray *)ids
{
    self.songListArrayM = list;
    self.songIdsArrayM = ids;
   
    [self reloadData];
}
- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
     
        
    }
    return self;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //HCLog(@"%ld",self.songListArrayM.count);
    return self.songListArrayM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYPublicSongDetailModel *songDetail = self.songListArrayM[indexPath.row];
       MYPublicTableViewCell *cell = [MYPublicTableViewCell publicTableViewCellcellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    cell.bePic = songDetail.pic_small ? YES : NO;
    cell.menuButton.tag = indexPath.row;
    cell.detailModel = songDetail;
    cell.delegate = self;
    [self updateIndicatorViewOfCell:cell];
    [cell setUpCellMenu];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据下拉菜单是否被打开，调整行高
    self.isOpen = self.isOpenCell && self.isOpenCell.isOpenMenu && (self.opendCellIndex.row == indexPath.row);
    if (self.isOpen) {
        return 100;
    }
    else{
        return 50;
    }
}

//选中cell进行播放
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index1 = indexPath.row;
    self.index1 = index1;
    MYPlayingViewController *viewController = [MYPlayingViewController sharePlayingVC];
    
    viewController.delegate = self;
    [viewController setSongIdArray:self.songIdsArrayM currentIndex:index1];
    [self updateIndicatorViewWithIndexPath:indexPath];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCScreenWidth, 10)];
    
    footer.backgroundColor = [UIColor clearColor];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
#pragma mark - cellDelegate代理方法
- (void)clickButton:(UIButton *)button openMenuOfCell:(MYPublicTableViewCell *)cell
{
    NSIndexPath *openIndex = [NSIndexPath indexPathForRow:button.tag inSection:0];
    if (self.isOpen) {
        self.isOpenCell = nil;//关闭
        [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];//refresh cell
        self.opendCellIndex = nil;
    }
    else{
        self.isOpenCell = cell;
        self.opendCellIndex = openIndex;
        [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
        [self scrollToRowAtIndexPath:self.opendCellIndex atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}
- (void)clickCellMenuItemAtIndex:(NSInteger)index Cell:(MYPublicTableViewCell *)cell
{
    // 点击后自动关闭
    self.isOpenCell = nil;
    [self reloadRowsAtIndexPaths:@[self.opendCellIndex] withRowAnimation:UITableViewRowAnimationFade];
    self.opendCellIndex = nil;
    
    switch (index) {
        case FavoriteItem:
            
            if (self.shoucang) {
                self.shoucang(cell.menuButton.tag);
            }
            
            break;

        case DeleteItem:
            [MYPromptTool promptModeText:@"无法删除网络资源" afterDelay:1];
            break;
    }
}
- (void)clickIndicatorView
{
    [[MYPlayingViewController sharePlayingVC] clickIndicator];
}

#pragma mark - update indicatorView state
- (void)updateIndicatorViewWithIndexPath:(NSIndexPath *)indexPath {
    for (MYPublicTableViewCell *cell in self.visibleCells) {
        //停止播放状态
        cell.indicatorViewState = NAKPlaybackIndicatorViewStateStopped;
    }
    MYPublicTableViewCell *musicsCell = [self cellForRowAtIndexPath:indexPath];
    //正在播放的状态
    musicsCell.indicatorViewState = NAKPlaybackIndicatorViewStatePlaying;
}
- (void)updateIndicatorViewOfCell:(MYPublicTableViewCell *)cell {
    MYPublicSongDetailModel *detail = cell.detailModel;
    if (detail.song_id == [MYPlayingViewController
                           sharePlayingVC].currentMusic.songId) {
        cell.indicatorViewState = [MYMusicIndicator shareIndicator].state;
    } else {
        cell.indicatorViewState = NAKPlaybackIndicatorViewStateStopped;
    }
}
#pragma mark - playingViewControllerDelegate
- (void)updateIndicatorViewOfVisisbleCells {
    for (MYPublicTableViewCell *cell in self.visibleCells) {
        [self updateIndicatorViewOfCell:cell];
    }
}
@end
