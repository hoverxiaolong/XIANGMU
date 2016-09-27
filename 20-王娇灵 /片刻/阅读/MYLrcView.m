//
//  MYLrcView.m
//  美物心语
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 bjsxt. All rights reserved.
//处理歌词

#import "MYLrcView.h"
#import "MYLrcModel.h"
#import "MYLrcLabel.h"
#import "MYLrcCell.h"
#import "MYCreatTool.h"
#import "View+MASAdditions.h"

#define HCScreen [[UIScreen mainScreen] bounds]

#define HCScreenWidth HCScreen.size.width

#define HCTitleFont [UIFont systemFontOfSize:20.0]
#define HCBigFont [UIFont systemFontOfSize:15.0]


@interface MYLrcView ()<UITableViewDataSource>
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@end
@implementation MYLrcView

#pragma mark - viewLoadAndLayout
- (instancetype)init
{
    if (self = [super init]) {
        [self setupTableView];
    }
    return self;
}
- (void)setupTableView
{
    self.tableView = [MYCreatTool tableViewWithView:self];
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 35;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.height.equalTo(self.mas_height).offset(-20);
        make.left.equalTo(self.mas_left).offset(HCScreenWidth);
        make.width.equalTo(self.mas_width);
    }];
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLrcCell *cell = [MYLrcCell lrcCellWithTableView:tableView];
    if (indexPath.row == self.currentIndex) {
        cell.lrcLabel.font = HCTitleFont;
    }
    else {
        cell.lrcLabel.font = HCBigFont;
        cell.lrcLabel.progress = 0;
    }
    MYLrcModel *lrcModel = self.lrcArray[indexPath.row];
    cell.lrcLabel.text = lrcModel.text;
    return cell;
}
#pragma mark - setter － NSStringToTime
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    // 找出对应时间的歌词
    NSInteger count = self.lrcArray.count;
    for (NSInteger i = 0; i < count; i++) {
        MYLrcModel *lrcline = self.lrcArray[i];
        //下一句
        NSInteger nextIndex = i + 1;
        if (nextIndex > count - 1){
            return;
        }
        MYLrcModel *nextLrcline = self.lrcArray[nextIndex];
        
//         对比两句歌词时间，处理歌曲快进的情况
        if (currentTime >= lrcline.time && currentTime < nextLrcline.time && self.currentIndex != i) {
//          上一句
            NSMutableArray *indexs = [NSMutableArray array];
            if (self.currentIndex < count - 1) {
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
                [indexs addObject:previousIndexPath];
            }
//            当前句
            self.currentIndex = i;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexs addObject:indexPath];
            
            [self.tableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
//            当前句居中
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        if (self.currentIndex == i) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            MYLrcCell *cell = (MYLrcCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.lrcLabel.progress = (currentTime - lrcline.time) / (nextLrcline.time - lrcline.time);
        }
    }
}
- (void)setLrcArray:(NSArray *)lrcArray
{
    _lrcArray = lrcArray;
    [self.tableView reloadData];
}
@end
